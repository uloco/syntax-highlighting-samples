module ModuleValidator {
  import checkChars = CharUtils.notWhiteSpace;
  export interface HasValidator<T> {
    validateValue(): Boolean;
  }

  class HasValidator implements HasValidator<String> {
    /* Processed values */
    static validatedValue: Array<String> = ["", "aa"];
    private myValue: String;

    /**
     * Constructor for <code>HasValidator</code> class
     * @param value for <i>validation</i>
     */
    constructor(valueParameter: String) { this.myValue = valueParameter; HasValidator.validatedValue.push(value);
    }

    public validateValue(): Boolean {
      var resultValue: Boolean = checkChars(this.myValue);
      this.createInstance()
      return resultValue;
    }

    static createInstance(valueParameter: String): HasValidator {
      return new HasValidator(valueParameter);
    }
  }

  function globalFunction<TypeParameter>(value: TypeParameter) { //global function
    return 42;
  }

  HasValidator.createInstance(varUrl).validateValue();
}
#
