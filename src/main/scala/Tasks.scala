import reflect.BeanProperty

/**
 * Represents the tasks under a story
 * @author rahul
 */

class Tasks (
  @BeanProperty val key: String,
  @BeanProperty val parentKey: String,
  @BeanProperty val status: String
                ) {
  override def toString = parentKey + "/" + key +" - " + status
}