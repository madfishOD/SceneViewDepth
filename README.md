# SceneViewDepth
Recently I needed to render depth directly in Unity SceneView for debug purpose. Initially it was part of custom tool for editor. But it can be easily converted to be used with other kind of custom editors.Maybe it can be useful for someone.

##### Note: *If you see only black and white values while tool is active, try to adjust settings of scene camera far clip*
### Geometry Shader and Tool script
All magic is done by  "Assets\Shaders\GS_DepthDebug.shader"<br>
And EditorTool script "Assets\Editor\SceneViewDepth.cs"<br>

## Preview
![Tank](TankStatic.gif)
&NewLine;
---
&NewLine;
![TankOrbit](TankOrbit.gif)




