package drcJS.core;

#if js

    typedef GL                  = drcJS.backend.web.core.GL;
    typedef GLActiveInfo        = drcJS.backend.web.core.GL.GLActiveInfo;
    typedef GLBuffer            = drcJS.backend.web.core.GL.GLBuffer;
    typedef GLContextAttributes = drcJS.backend.web.core.GL.GLContextAttributes;
    typedef GLFramebuffer       = drcJS.backend.web.core.GL.GLFramebuffer;
    typedef GLProgram           = drcJS.backend.web.core.GL.GLProgram;
    typedef GLRenderbuffer      = drcJS.backend.web.core.GL.GLRenderbuffer;
    typedef GLShader            = drcJS.backend.web.core.GL.GLShader;
    typedef GLTexture           = drcJS.backend.web.core.GL.GLTexture;
    typedef GLUniformLocation   = drcJS.backend.web.core.GL.GLUniformLocation;

#elseif cpp

    typedef GL                  = opengl.WebGL;
    typedef GLActiveInfo        = opengl.WebGL.GLActiveInfo;
    typedef GLBuffer            = opengl.WebGL.GLBuffer;
    typedef GLContextAttributes = opengl.WebGL.GLContextAttributes;
    typedef GLFramebuffer       = opengl.WebGL.GLFramebuffer;
    typedef GLProgram           = opengl.WebGL.GLProgram;
    typedef GLRenderbuffer      = opengl.WebGL.GLRenderbuffer;
    typedef GLShader            = opengl.WebGL.GLShader;
    typedef GLTexture           = opengl.WebGL.GLTexture;
    typedef GLUniformLocation   = opengl.WebGL.GLUniformLocation;

#end //!snow_web