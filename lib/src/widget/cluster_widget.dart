import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_supercluster/src/layer/alignment_util.dart';
import 'package:flutter_map_supercluster/src/layer/map_camera_extension.dart';
import 'package:flutter_map_supercluster/src/layer_element_extension.dart';
import 'package:supercluster/supercluster.dart';

import '../layer/cluster_data.dart';
import '../layer/supercluster_layer.dart';

class ClusterWidget extends StatelessWidget {
  final LayerCluster<Marker> cluster;
  final ClusterWidgetBuilder builder;
  final VoidCallback onTap;
  final Size size;
  final Offset position;
  final double mapRotationRad;
  final Alignment alignment;

  ClusterWidget({
    Key? key,
    required MapCamera mapCamera,
    required this.cluster,
    required this.builder,
    required this.onTap, // On tap has no effect since we disable expansion
    required this.size,
    required this.alignment,
  })  : position = _getClusterPixel(
          mapCamera,
          cluster,
          alignment,
          size,
        ),
        mapRotationRad = mapCamera.rotationRad,
        super(key: ValueKey(cluster.uuid));

  @override
  Widget build(BuildContext context) {
    final clusterData = cluster.clusterData as ClusterData;

    return Positioned(
      width: size.width,
      height: size.height,
      left: position.dx,
      top: position.dy,
      child: Transform.rotate(
        angle: -mapRotationRad,
        child: builder(
          context,
          cluster.latLng,
          clusterData.markerCount,
          clusterData.innerData,
        ),
      ),
    );
  }

  static Offset _getClusterPixel(
    MapCamera mapCamera,
    LayerCluster<Marker> cluster,
    Alignment alignment,
    Size size,
  ) {
    return AlignmentUtil.applyAlignment(
      mapCamera.getPixelOffset(cluster.latLng),
      size.width,
      size.height,
      alignment,
    );
  }
}
