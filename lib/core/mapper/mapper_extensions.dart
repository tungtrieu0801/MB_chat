import 'package:mobile_trip_togethor/core/mapper/base_mapper.dart';

//List model => List entity
extension BaseMapperListExtension<T> on List<BaseMapper<T>> {
  List<T> toEntityList() => map((e) => e.toEntity()).toList();
}

//List enitty => List model
extension FromEntityList<T, M extends BaseMapper<T>> on List<T> {
  List<M> toModelList(M Function(T entity) fromEntityFn) {
    return map((e) => fromEntityFn(e)).toList();
  }
}
