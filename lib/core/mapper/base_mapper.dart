abstract class BaseMapper<T> {
  //Model => Entity
  T toEntity();

  //Entity => Model
  BaseMapper<T> fromEntity(T entity);
}
