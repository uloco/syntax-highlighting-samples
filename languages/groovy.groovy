import javax.swing.JPanel
  ### 
/**
 * This is Groovydoc comment
 * @see java.lang.String#equals
 */
@SpecialBean 
class Demo {
  public Demo() {}
  def property
//This is a line comment
/* This is a block comment */
  static def foo(int i, int j) {
    Map map = [key:1, b:2]
    j++
    print map.key
    return [i, property]
  }
  static def panel = new JPanel()
  def <T> foo() {    T list = null  }
}

Demo.panel.size = Demo.foo("123${456}789".toInteger()) 
'JetBrains'.matches(/Jw+Bw+/) 
def x=1 + unresolved
label:def f1 = []
f1 = [2]
File f=['path']
print new Demo().property
print '\n \x'

def notifyFailed() {
  emailext (
    foobar: [[$class: 'wtf']]
  )
}
