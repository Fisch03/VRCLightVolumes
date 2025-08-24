[VRC Light Volumes](../README.md) | [How to Use](../Documentation/HowToUse.md) | **Best Practices** | [Udon Sharp API](../Documentation/UdonSharpAPI.md) | [For Shader Developers](../Documentation/ForShaderDevelopers.md) | [Compatible Shaders](../Documentation/CompatibleShaders.md)

# Best Practices

| Menu |
| ----|
| **Best Practices**<br />• [Regular Light Volumes Use Cases](#Regular-Light-Volumes-Use-Cases)<br />• [Point Light Volumes Use Cases](#Point-Light-Volumes-Use-Cases)<br />• [Naming Light Volumes](#Quick-Light-Probe-Setup)<br />• [Volume Bounds Smoothing](#Volume-Bounds-Smoothing)<br />• [Culling Light Volumes](#Culling-Light-Volumes)<br />• [Moving Light Volumes](#Moving-Light-Volumes)<br />• [Movable Volumes As Light Sources](Movable-Volumes-As-Light-Sources)<br />• [Bakery Volume Rotation](#Bakery-Volume-Rotation)<br />• [Fixing Bakery Light Probes](#Fixing-Bakery-Light-Probes)<br />• [Spawning New Light Volumes In Runtime](#Spawning-New-Light-Volumes-In-Runtime) |

## Regular Light Volumes Use Cases

- Use them with small static props that usually require very high lightmap resolution to avoid visible seams. Light Volumes produce no seams at all, as they are voxel-based.
- Dynamic batching support: if you have tons of low-poly dynamic props across your scene using the same material, and their Mesh Renderers have Light Probes and Reflection Probes disabled, they can be dynamically batched at runtime, potentially improving performance.
- Combine Light Volumes with particles to create stunning volumetric fog effects.
- Switch between two Light Volumes at runtime to create toggleable lighting for rooms or other areas in your scene.
- TV Screens dynamic Global Illumination
- Audio Link Dynamic Lights
- And much more!

## Point Light Volumes Use Cases

- Spot Lights as portable flashlights
- Point Lights as other dynamic light sources
- Area Lights as studio light soft boxes
- Moving blinking lighting for clubs
- Image and cubemaps projectors
- TV Screens dynamic Global Illumination
- Audio Link Dynamic Lights
- And much more!

## Naming Light Volumes

Ensure every Light Volume you bake has a unique game object name. The generated 3D textures inherit these names and can conflict. If you duplicate baked volumes or use prefab instances with the `Bake` flag disabled, you don’t need to rename them.

## Volume Bounds Smoothing

Overlap intersecting volumes slightly (about 0.25 m) to hide seams. The `Smooth Blending` parameter controls edge falloff - keep it smaller than your overlap.

To smooth between a volume and uncovered areas, disable `Sharp Bounds` in Light Volume Setup. This applies smoothing to all edges, so you might need to scale up your volumes to keep the softened edges outside of the intended area.

## Culling Light Volumes

At runtime, you can disable any Light Volume to exclude it from rendering. This works even on non-dynamic volumes. Manually culling unused volumes can significantly boost performance in large scenes.

Disabling **Light Volumes Manager** object disables all the Light Volumes system and fallbacks all the shaders to light probes.

## Moving Light Volumes

To update a volume’s transform at runtime, enable **Dynamic** on its component and check **Auto Update Volumes** in Light Volume Setup. Otherwise, you must manually update positions of Dynamic volumes via an Udon script. If you don’t need runtime updates, leave both options off for better performance.

## Movable Volumes

For dynamic lighting, set the volume to **Additive** so it layers on top of others and also affects lightmapped static meshes with a compatible shader. Minimize overlapping additive volumes to reduce overhead. Use **Max Additive Overdraw** value in Light Volume Setup to limit how many additive volumes render (prioritizing those with higher weight). Setting it to zero disables additive volumes entirely.

## Bakery Volume Rotation

Bakery lightmapper offers high quality with Light Volumes but may not support rotation during baking in some older versions. Upgrade to the latest Bakery Patch (via **Bakery → Utilities → Check for Patches**) to support full rotation. Runtime rotation is still always supported.

## Fixing Bakery Light Probes

Bakery bakes L1 probes to work with "Geometrics SH Evaluation", which can cause overexposure and underexposure issues. Enable **Fix Light Probes L1** in Light Volume Setup to correct the probes after each bake. This may reduce overall contrast slightly but prevents over or underexposure.

## Spawning New Light Volumes In Runtime

You can spawn and auto-initialize both Light Volumes and Point Light Volumes in runtime. To do that, first, setup your light volume in editor and configure it as you wish. Then, you need to remove the `Light Volume` or the `Point Light Volume` component from it, to leave only the **Udon Sharp Instance script** there. Then, uncheck the `Is Initialized` flag, it will make this object auto initialize every time it spawns. Then, you can spawn it as a prefab with native `Instantiate()` method, or with help of the VRC SDK3 `VRC Player Object` component.
