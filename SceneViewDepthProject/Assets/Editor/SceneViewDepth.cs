
using UnityEditor;
using UnityEditor.EditorTools;
using UnityEngine;


[EditorTool("SceneViewDepth")]
public class SceneViewDepth : EditorTool
{

    public Shader _depthDebugShader;

    private Camera      _sceneCamera;
    private bool        _depthDebug;
    private Material    _depthDebugMaterial;


    private bool _toolStateIsActive;  

    private void OnEnable()
    {
        EditorTools.activeToolChanged += OnActiveToolDidChange;
        SceneView.duringSceneGui      += DuringSceneGui;
        Camera.onPostRender           += PostRender;
    }

    private void OnDisable()
    {
        EditorTools.activeToolChanged -= OnActiveToolDidChange;
        SceneView.duringSceneGui      -= DuringSceneGui;
        Camera.onPostRender           -= PostRender;
    }

    private void OnActiveToolDidChange()
    {
        _toolStateIsActive = EditorTools.IsActiveTool(this);

    }
    //// All stuff running in scene view
    private void DuringSceneGui(SceneView sceneView)
    {
        if (_sceneCamera == null && Camera.current != null)
            _sceneCamera = Camera.current;
    }
    //// All stuff as postprocess-like effects include some debug goes here
    private void PostRender(Camera cam)
    {
        if (!_toolStateIsActive)
            return;
        if (cam != _sceneCamera)        //Need to check if camera is scene camera to avoid some artifacts in inspector and other editor windows
            return;             
        DebugDrawDepth();           //Try to tweak scene camera far clip manualy if you see just black shiluettes
    }

    //// Draw fullscreen plane with depth texture using specifyied shader
    void DebugDrawDepth()
    {
        if (_depthDebugShader == null)
        {
            Debug.LogError("_depthDebugShader is null! Check settings asset please");
            return;
        }
        // Create new material instance if it's null
        if (_depthDebugMaterial == null)
            _depthDebugMaterial = new Material(_depthDebugShader);
        // Proceduraly draw quad with depth texture
        _depthDebugMaterial.SetPass(0);
        Graphics.DrawProceduralNow( MeshTopology.Points, 1 );
    }
}
