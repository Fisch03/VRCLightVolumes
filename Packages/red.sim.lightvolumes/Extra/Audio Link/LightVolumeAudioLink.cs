using UnityEngine;

#if UDONSHARP
using UdonSharp;
using VRC.SDKBase;
#else
using VRCShader = UnityEngine.Shader;
#endif

namespace VRCLightVolumes {

#if UDONSHARP
    [UdonBehaviourSyncMode(BehaviourSyncMode.None)]
    public class LightVolumeAudioLink : UdonSharpBehaviour
#else
    public class LightVolumeAudioLink : MonoBehaviour
#endif
    {
#if AUDIOLINK
        [Tooltip("Reference to your Audio Link manager that should control Light Volumes")]
        public AudioLink.AudioLink AudioLink;
        [Tooltip("Defines which audio band will be used to control Light Volumes. Four bands available: Bass, Low Mid, High Mid, Treble")]
        public AudioLinkBand AudioBand = AudioLinkBand.Bass;
        [Tooltip("Defines how many samples back in history we're getting data from. Can be a value from 0 to 127. Zero means no delay at all")]
        [Range(0, 127)] public int Delay = 0;
        [Tooltip("Enables smoothing algorithm that tries to smooth out flickering that can usually be a problem")]
        public bool SmoothingEnabled = true;
        [Tooltip("Value from 0 to 1 that defines how much smoothing should be applied. Zero usually applies just a little bit of smoothing. One smoothes out almost all the fast blinks and makes intensity changing very slow")]
        [Range(0, 1)] public float Smoothing = 0.25f;

        [Tooltip("Value added to intensity at AudioLink minimum")]
        public float MinimumAdd = 0f;
        [Tooltip("Value added to intensity at AudioLink maximum")]
        public float MaximumAdd = 0f;

        [Tooltip("Value multiplied with intensity at AudioLink minimum")]
        public float MinimumMultiply = 1f;
        [Tooltip("Value multiplied with intensity at AudioLink maximum")]
        public float MaximumMultiply = 1f;

        [Space]
        [Tooltip("Auto uses Theme Colors 0, 1, 2, 3 for Bass, LowMid, HighMid, Treble. Override Color allows you to set the static color value")]
        public AudioLinkColor ColorMode = AudioLinkColor.Auto;
        [Tooltip("Color that will be used when Override Color is enabled")]
        [ColorUsage(showAlpha: false)] public Color Color = Color.white;

        [Tooltip("Enable to set the base color of the material to the light color")]
        public bool SetBaseColor = false;
        [Tooltip("Brightness multiplier of the materials that should change color based on AudioLink. Intensity for Light Volumes and Point Light Volumes should be setup in their components")]
        public float MaterialsIntensity = 2f;

        [Space]
        [Tooltip("List of the Light Volumes that should be affected by AudioLink")]
        public LightVolumeInstance[] TargetLightVolumes;
        [Tooltip("List of the Point Light Volumes that should be affected by AudioLink")]
        public PointLightVolumeInstance[] TargetPointLightVolumes;
        [Tooltip("List of the Mesh Renderers that has materials that should change color based on AudioLink")]
        public Renderer[] TargetMeshRenderers;

        // shader property IDs
        private int _colorID;
        private int _emissionColorID;
        private int _emissionStrengthID;

        private MaterialPropertyBlock _block;
        private float _prevData = 0f;

        // storage for the base intensity values
        private float[] _pvBaseIntensity;
        private float[] _vBaseIntensity;
        private float[] _mBaseIntensity;

        private void InitIDs() {
            _colorID = VRCShader.PropertyToID("_Color");
            _emissionColorID = VRCShader.PropertyToID("_EmissionColor");
            _emissionStrengthID = VRCShader.PropertyToID("_EmissionStrength");
        }

        private void Start() {
            _block = new MaterialPropertyBlock();
            InitIDs();
            Color _color;

            if (AudioLink != null) {
                AudioLink.EnableReadback();
            }

            // find base intensity values
            int _count = TargetLightVolumes.Length;
            _vBaseIntensity = new float[_count];
            for (int i = 0; i < TargetLightVolumes.Length; i++) {
                _vBaseIntensity[i] = TargetLightVolumes[i].Intensity;
            }

            _count = TargetPointLightVolumes.Length;
            _pvBaseIntensity = new float[_count];
            for (int i = 0; i < TargetPointLightVolumes.Length; i++) {
                _pvBaseIntensity[i] = TargetPointLightVolumes[i].Intensity;
            }

            _count = TargetMeshRenderers.Length;
            _mBaseIntensity = new float[_count];
            for (int i = 0; i < TargetMeshRenderers.Length; i++) {
                _mBaseIntensity[i] = TargetMeshRenderers[i].material.GetFloat(_emissionStrengthID);
            }
        }

        private void Update() {
            int band = (int)AudioBand;

            // choose color
            Color _color = Color.black;
            switch (ColorMode) {
                case AudioLinkColor.NoChange:
                    break;
                case AudioLinkColor.Auto:
                    // wrap this around because of the size mismatch between number
                    // of bands and number of colors
                    _color = AudioLink.GetDataAtPixel(band % 4, 23);
                    break;
                case AudioLinkColor.OverrideColor:
                    _color = Color;
                    break;
                default:
                    _color = AudioLink.GetDataAtPixel((int) ColorMode, 23);
                    break;
            }

            float alData = SampleALData(Delay, band);

            int _count = TargetLightVolumes.Length;
            for (int i = 0; i < _count; i++) {
                TargetLightVolumes[i].Intensity =
                    ApplyALFactors(_vBaseIntensity[i], alData);

                if (ColorMode != AudioLinkColor.NoChange) {
                   TargetPointLightVolumes[i].Color = _color;
                }
            }

            _count = TargetPointLightVolumes.Length;
            for (int i = 0; i < _count; i++) {
                TargetPointLightVolumes[i].IsRangeDirty = true;
                TargetPointLightVolumes[i].Intensity =
                    ApplyALFactors(_pvBaseIntensity[i], alData);

                if (ColorMode != AudioLinkColor.NoChange) {
                   TargetPointLightVolumes[i].Color = _color;
                }
            }

            _count = TargetMeshRenderers.Length;
            for (int i = 0; i < _count; i++) {
                TargetMeshRenderers[i].GetPropertyBlock(_block, 0);

                if (ColorMode != AudioLinkColor.NoChange) {
                    _block.SetColor(_emissionColorID, _color);
                    if (SetBaseColor) {
                        _block.SetColor(_colorID, _color);
                    }
                }

                _block.SetFloat(_emissionStrengthID,
                    ApplyALFactors(_mBaseIntensity[i] * MaterialsIntensity, alData));

                TargetMeshRenderers[i].SetPropertyBlock(_block);
            }
        }

        private float ApplyALFactors(float input, float alData) {
            float output = input;
            output += Mathf.Lerp(MinimumAdd, MaximumAdd, alData);
            output *= Mathf.Lerp(MinimumMultiply, MaximumMultiply, alData);
            return output;
        }

        private float SampleALData(int delay, int band) {
            float alData = 0f;

            // sample from ALPASS_GENERALVU + (8, 0) to get volume (RMS Left)
            // note that we don't get delay here.
            if (band == (int) AudioLinkBand.Volume) {
                alData = AudioLink.GetDataAtPixel(8, 22).x;
            }
            else {
                // sample the audiolink band data from ALPASS_AUDIOLINK
                // when delay is 0 or ALPASS_AUDIOLINKHISTORY when > 0
                alData = AudioLink.GetDataAtPixel(delay, band).x;
            }

            if (SmoothingEnabled) {
                float diff = Mathf.Abs(Mathf.Abs(alData) - Mathf.Abs(_prevData));

                // Smoothing speed depends on the color difference
                float smoothing = Time.deltaTime / Mathf.Lerp(Mathf.Lerp(0.25f, 1f, Smoothing), Mathf.Lerp(1e-05f, 0.1f, Smoothing), Mathf.Pow(diff * 1.5f, 0.1f));

                // Actually smoothing the value
                _prevData = Mathf.Lerp(_prevData, alData, smoothing);
            }
            return alData;
        }


        private float ColorDifference(Color colorA, Color colorB) {
            float rmean = (colorA.r + colorB.r) * 0.5f;
            float r = colorA.r - colorB.r;
            float g = colorA.g - colorB.g;
            float b = colorA.b - colorB.b;
            return Mathf.Sqrt((2f + rmean) * r * r + 4f * g * g + (3f - rmean) * b * b) / 3;
        }

        private void OnValidate() {
            if (AudioLink != null) {
                AudioLink.EnableReadback();
            }
        }

#endif
    }

    public enum AudioLinkBand {
        Bass = 0,
        LowMid = 1,
        HighMid = 2,
        Treble = 3,
        Volume = 4
    }

    public enum AudioLinkColor {
        Auto = -1,
        ThemeColor0 = 0,
        ThemeColor1 = 1,
        ThemeColor2 = 2,
        ThemeColor3 = 3,
        OverrideColor = 4,
        NoChange = 5
    }

}
