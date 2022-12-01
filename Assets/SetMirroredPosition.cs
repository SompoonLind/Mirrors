using UnityEngine;

[ExecuteInEditMode]

public class SetMirroredPosition : MonoBehaviour
{

    public GameObject mirrorQuad;
    public Camera mainCamera;
    public bool isMainCameraStereo;
    public bool useRightEye;

    void LateUpdate()
    {
        if (null != mirrorQuad && null != mainCamera &&
            null != mainCamera.GetComponent<Camera>())
        {
            Vector3 mainCameraPosition;
            if (!isMainCameraStereo)
            {
                mainCameraPosition = mainCamera.transform.position;
            }
            else
            {
                Matrix4x4 viewMatrix = mainCamera.GetStereoViewMatrix(
                    useRightEye ? Camera.StereoscopicEye.Right :
                    Camera.StereoscopicEye.Left);
                mainCameraPosition = viewMatrix.inverse.GetColumn(3);
            }
            Vector3 positionInMirrorSpace =
                mirrorQuad.transform.InverseTransformPoint(mainCameraPosition);
            positionInMirrorSpace.z = -positionInMirrorSpace.z;
            transform.position =
                mirrorQuad.transform.TransformPoint(
                    positionInMirrorSpace);
        }
    }
}