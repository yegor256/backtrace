[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/backtrace)](http://www.rultor.com/p/yegor256/backtrace)
[![We recommend RubyMine](http://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![Build Status](https://travis-ci.org/yegor256/backtrace.svg)](https://travis-ci.org/yegor256/backtrace)
[![Gem Version](https://badge.fury.io/rb/backtrace.svg)](http://badge.fury.io/rb/backtrace)
[![Maintainability](https://api.codeclimate.com/v1/badges/349b8c31884d3b34d926/maintainability)](https://codeclimate.com/github/yegor256/backtrace/maintainability)

A Ruby backtrace nicely printed.

First, install it:

```bash
$ gem install backtrace
```

Then, use it like this, to print a backtrace:

```ruby
require 'backtrace'
begin
  # do something dangerous
rescue StandardError => e
  puts Backtrace.new(e)
end
```

# License

(The MIT License)

Copyright (c) 2018 Yegor Bugayenko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
