@decorator(param=1)
def f(x):
    """ Syntax Highlighting Demo
        @param x Parameter"""
    s = ("Test", 2+3, {'a': 'b'}, x)   # Comment
    print s[0].lower()
    for t in s:
        if t in s:
            print('sorry') 
            x & s


class Foo:
    def __init__(self):
        byte_string = 'newline:\n also newline:\x0a'
        text_string = u"Cyrillic Я is \u042f. Oops: \u042g"
        self.makeSense(whatever=1)

    def makeSense(self, whatever):
        self.sense = whatever
        if True:
            pass

x = len('abc')
print(f.__doc__)

# nested `in` operator
available_toppings = []
requested_toppings = ['mushrooms', 'french fries', 'extra cheese']
for requested_topping in requested_toppings:
    if requested_topping in available_toppings:
        print(f'Sorry, we do not have {requested_topping}')
print('finished making your pizza!')

