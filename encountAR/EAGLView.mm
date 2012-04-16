/*==============================================================================
 Copyright (c) 2012 QUALCOMM Austria Research Center GmbH.
 All Rights Reserved.
 Qualcomm Confidential and Proprietary
 ==============================================================================*/

// Subclassed from AR_EAGLView
#import "EAGLView.h"
#import "Teapot.h"
#import "Texture.h"
#import "AppDelegate.h"

#import <QCAR/Renderer.h>
#import <QCAR/Vectors.h>
#import <QCAR/CameraDevice.h>

#import "QCARutils.h"


#ifndef USE_OPENGL1
#import "ShaderUtils.h"
#endif

namespace {
    // Teapot texture filenames
    const char* textureFilenames[] = {
        "TextureTeapotBrass.png",
        "TextureTeapotBlue.png",
        "TextureTeapotRed.png"
    };

    // Model scale factor
    const float kObjectScale = 3.0f;
}

@interface EAGLView()
- (CGPoint) projectCoord:(CGPoint)coord inView:(const QCAR::CameraCalibration&)cameraCalibration andPose:(QCAR::Matrix34F)pose withOffset:(CGPoint)offset;
- (void) calcScreenCoordsOf:(CGSize)target inView:(CGFloat *)matrix inPose:(QCAR::Matrix34F)pose;
@end


@implementation EAGLView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
	if (self)
    {
        // create list of textures we want loading - ARViewController will do this for us
        int nTextures = sizeof(textureFilenames) / sizeof(textureFilenames[0]);
        for (int i = 0; i < nTextures; ++i)
            [textureList addObject: [NSString stringWithUTF8String:textureFilenames[i]]];
    }
    return self;
}

- (void) setup3dObjects
{
    // build the array of objects we want drawn and their texture
    // in this example we have 3 targets and require 3 models
    // but using the same underlying 3D model of a teapot, differentiated
    // by using a different texture for each
    
    for (int i=0; i < [textures count]; i++)
    {
        Object3D *obj3D = [[Object3D alloc] init];

        obj3D.numVertices = NUM_TEAPOT_OBJECT_VERTEX;
        obj3D.vertices = teapotVertices;
        obj3D.normals = teapotNormals;
        obj3D.texCoords = teapotTexCoords;
        
        obj3D.numIndices = NUM_TEAPOT_OBJECT_INDEX;
        obj3D.indices = teapotIndices;
        
        obj3D.texture = [textures objectAtIndex:i];

        [objects3D addObject:obj3D];
        [obj3D release];
    }
}


// called after QCAR is initialised but before the camera starts
- (void) postInitQCAR
{
    // These two calls to setHint tell QCAR to split work over multiple
    // frames.  Depending on your requirements you can opt to omit these.
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MULTI_FRAME_ENABLED, 1);
    QCAR::setHint(QCAR::HINT_IMAGE_TARGET_MILLISECONDS_PER_MULTI_FRAME, 25);
    
    // Here we could also make a QCAR::setHint call to set the maximum
    // number of simultaneous targets                
    // QCAR::setHint(QCAR::HINT_MAX_SIMULTANEOUS_IMAGE_TARGETS, 2);
}

// modify renderFrameQCAR here if you want a different 3D rendering model
////////////////////////////////////////////////////////////////////////////////
// Draw the current frame using OpenGL
//
// This method is called by QCAR when it wishes to render the current frame to
// the screen.
//
// *** QCAR will call this method on a single background thread ***

- (void) hideView {
    [self performSelectorOnMainThread:@selector(hView) withObject:nil waitUntilDone:NO];
}

- (void) showView {
    [self performSelectorOnMainThread:@selector(sView) withObject:nil waitUntilDone:NO];
}

- (void) hView {
     [app hideView];
}

- (void) sView {
     [app showView];
}


- (void)renderFrameQCAR
{
    [self setFramebuffer];
    
    // Clear colour and depth buffers
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Render video background and retrieve tracking state
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    
    //NSLog(@"[DEBUG] active trackables: %d", state.getNumActiveTrackables());
    
    if (QCAR::GL_11 & qUtils.QCARFlags) {
        glEnable(GL_TEXTURE_2D);
        glDisable(GL_LIGHTING);
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_NORMAL_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }
    
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    
    
    if (state.getNumActiveTrackables() == 0){
        [self hideView];
    
    }
    
    for (int i = 0; i < state.getNumActiveTrackables(); ++i) {
        // Get the trackable
        const QCAR::Trackable* trackable = state.getActiveTrackable(i);
        QCAR::Matrix44F modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(trackable->getPose());
        
        // Choose the texture based on the target name
        int targetIndex = 0;
        if (!strcmp(trackable->getName(), "588"))
            targetIndex = 1;
        else if (!strcmp(trackable->getName(), "598"))
            targetIndex = 2;
        else if (!strcmp(trackable->getName(), "Potato_Peeling"))
            targetIndex = 3;
        
        
        Object3D *obj3D = [objects3D objectAtIndex:targetIndex];
        
        // Render using the appropriate version of OpenGL
        if (QCAR::GL_11 & qUtils.QCARFlags) {
            // Load the projection matrix
            glMatrixMode(GL_PROJECTION);
            glLoadMatrixf(qUtils.projectionMatrix.data);
            
            // Load the model-view matrix
            glMatrixMode(GL_MODELVIEW);
            glLoadMatrixf(modelViewMatrix.data);
            glTranslatef(0.0f, 0.0f, -kObjectScale);
            glScalef(kObjectScale, kObjectScale, kObjectScale);
            
            // Draw object
            glBindTexture(GL_TEXTURE_2D, [obj3D.texture textureID]);
            glTexCoordPointer(2, GL_FLOAT, 0, (const GLvoid*)obj3D.texCoords);
            glVertexPointer(3, GL_FLOAT, 0, (const GLvoid*)obj3D.vertices);
            glNormalPointer(GL_FLOAT, 0, (const GLvoid*)obj3D.normals);
            glDrawElements(GL_TRIANGLES, obj3D.numIndices, GL_UNSIGNED_SHORT, (const GLvoid*)obj3D.indices);
        }
#ifndef USE_OPENGL1
        else {
            // OpenGL 2
            QCAR::Matrix44F modelViewProjection;
            
            ShaderUtils::translatePoseMatrix(0.0f, 0.0f, kObjectScale, &modelViewMatrix.data[0]);
            ShaderUtils::scalePoseMatrix(kObjectScale, kObjectScale, kObjectScale, &modelViewMatrix.data[0]);
            ShaderUtils::multiplyMatrix(&qUtils.projectionMatrix.data[0], &modelViewMatrix.data[0], &modelViewProjection.data[0]);
            
            if ((targetIndex == 1) || (targetIndex == 2) || (targetIndex == 3)){
                
                
                app.artNum = targetIndex;
                const QCAR::ImageTarget* imageTarget = static_cast<const QCAR::ImageTarget*>(trackable);
                QCAR::Vec2F::Vec2F screenPoint = imageTarget->getSize();
                
                CGSize target;
                target.width = screenPoint.data[0];
                target.height = screenPoint.data[1];
                
                //CGSize target = {247,173};
                
                
                //NSLog(@"[DEBUG] height %f", target.height);
                //NSLog(@"[DEBUG] width %f", target.width);       
                //CGRect rect = 
                [self calcScreenCoordsOf:target inView:&modelViewProjection.data[0] inPose:trackable->getPose()];
                
                //app.imageRect =rect;
                [self showView];
                
                
                
            } 

            glUseProgram(shaderProgramID);
            
            glVertexAttribPointer(vertexHandle, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)obj3D.vertices);
            glVertexAttribPointer(normalHandle, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)obj3D.normals);
            glVertexAttribPointer(textureCoordHandle, 2, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)obj3D.texCoords);
            
            glEnableVertexAttribArray(vertexHandle);
            glEnableVertexAttribArray(normalHandle);
            glEnableVertexAttribArray(textureCoordHandle);
            
            glActiveTexture(GL_TEXTURE0);
            glBindTexture(GL_TEXTURE_2D, [obj3D.texture textureID]);
            glUniformMatrix4fv(mvpMatrixHandle, 1, GL_FALSE, (const GLfloat*)&modelViewProjection.data[0]);
            //TONY COMMENT OUT THIS LINE TO REMOVE TEAPOT
            //glDrawElements(GL_TRIANGLES, obj3D.numIndices, GL_UNSIGNED_SHORT, (const GLvoid*)obj3D.indices);
            
            ShaderUtils::checkGlError("EAGLView renderFrameQCAR");
        }
#endif
    }
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    
    if (QCAR::GL_11 & qUtils.QCARFlags) {
        glDisable(GL_TEXTURE_2D);
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_NORMAL_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    }
#ifndef USE_OPENGL1
    else {
        glDisableVertexAttribArray(vertexHandle);
        glDisableVertexAttribArray(normalHandle);
        glDisableVertexAttribArray(textureCoordHandle);
    }
#endif
    
    QCAR::Renderer::getInstance().end();
    [self presentFramebuffer];
}

#pragma mark - Other Utility Fns
- (CGPoint) projectCoord:(CGPoint)coord inView:(const QCAR::CameraCalibration&)cameraCalibration andPose:(QCAR::Matrix34F)pose withOffset:(CGPoint)offset
{
    CGPoint converted;
    
    QCAR::Vec3F vec(coord.x,coord.y,0);
    QCAR::Vec2F sc = QCAR::Tool::projectPoint(cameraCalibration, pose, vec);
    converted.x = sc.data[0] - offset.x;
    converted.y = sc.data[1] - offset.y;
    
    return converted;
}

- (void) calcScreenCoordsOf:(CGSize)target inView:(CGFloat *)matrix inPose:(QCAR::Matrix34F)pose
{
    // 0,0 is at centre of target so extremities are at w/2,h/2
    CGFloat w = target.width/2;
    CGFloat h = target.height/2;
    
    // need to account for the orientation on view size
    CGFloat viewWidth = self.frame.size.height; // Portrait
    CGFloat viewHeight = self.frame.size.width; // Portrait    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        viewWidth = self.frame.size.width;
        viewHeight = self.frame.size.height;        
    }
    
    // calculate any mismatch of screen to video size
    QCAR::CameraDevice& cameraDevice = QCAR::CameraDevice::getInstance();
    const QCAR::CameraCalibration& cameraCalibration = cameraDevice.getCameraCalibration();
    QCAR::VideoMode videoMode = cameraDevice.getVideoMode(QCAR::CameraDevice::MODE_DEFAULT);
    CGPoint margin = {(videoMode.mWidth - viewWidth)/2, (videoMode.mHeight - viewHeight)/2};
    
    // now project the 4 corners of the target
    app.s0 = [self projectCoord:CGPointMake(-w,h) inView:cameraCalibration andPose:pose withOffset:margin];
    app.s1 = [self projectCoord:CGPointMake(-w,-h) inView:cameraCalibration andPose:pose withOffset:margin];
    app.s2 = [self projectCoord:CGPointMake(w,-h) inView:cameraCalibration andPose:pose withOffset:margin];
    app.s3 = [self projectCoord:CGPointMake(w,h) inView:cameraCalibration andPose:pose withOffset:margin];
    app.artCoord = [self projectCoord:CGPointMake(-w,-h) inView:cameraCalibration andPose:pose withOffset:margin];
}


@end
