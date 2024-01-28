import time
import os
import json

def define_env(env):
    """
    This is the hook for the functions

    - variables: the dictionary that contains the variables
    - macro: a decorator function, to declare a macro.
    """
    with open('/docs/source/docs/revision.json') as json_file:
        env.variables['revisions'] = json.load(json_file)

    define_env.dateFormat = env.variables['date format'] if 'date format' in env.variables else "%Y-%m-%d %H:%M"

    env.variables['baz'] = "John Doe"
    env.variables['time'] = time.strftime(define_env.dateFormat, time.localtime())


    @env.macro
    def bar(x):
        return (2.3 * x) + 7

    # If you wish, you can  declare a macro with a different name:
    def f(x):
        return x * x

    @env.macro
    def changedate():
        path = env.variables['page'].file.src_path
        revs = env.variables['revisions']
        if not path in revs:
            return ''
        f = time.strptime(revs[path]['Date'], '%Y-%m-%d %H:%M:%S')
        s = time.strftime(define_env.dateFormat, f)
        return s

    env.macro(f, 'barbaz')

    # or to export some predefined function
    import math
    env.macro(math.floor) # will be exported as 'floor'

    # create a jinja2 filter
    @env.filter
    def reverse(x):
        "Reverse a string (and uppercase)"
        return x.upper()[::-1]
