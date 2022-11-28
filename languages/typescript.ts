module ModuleValidator {
  import checkChars = CharUtils.notWhiteSpace;
  export interface HasValidator<T> {
    validateValue(): Boolean;
  }

  let x = "hello" as string;

  type A =
    | string
    | number
    | null
    | undefined
    | Record<string, null>
    | { a: string; b: string };

  type B<T> = T extends string ? string : never;

  class Has extends Foo { }

  class HasValidator implements HasValidator<String> {
    /* Processed values */
    static validatedValue: Array<String> = ["", "aa"];
    private myValue: String;

    /**
     * Constructor for <code>HasValidator</code> class
     * @param value for <i>validation</i>
     */
    constructor(valueParameter: String) {
      this.myValue = valueParameter;
      HasValidator.validatedValue.push(value);
    }

    public validateValue(): Boolean {
      var resultValue: Boolean = checkChars(this.myValue);
      this.createInstance();
      return resultValue;
    }

    static createInstance(valueParameter: String): HasValidator {
      return new HasValidator(valueParameter);
    }
  }

  function globalFunction<TypeParameter>(value: TypeParameter) {
    //global function
    return 42;
  }

  HasValidator.createInstance(varUrl).validateValue();
}

function assertIsString(val: any): asserts val is string {
  if (typeof val !== "string") {
    throw new AssertionError("Not a string!");
  }
}

class Jockl extends Error {

}

const thisConstant = "foo"
