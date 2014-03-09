# Backuppc-server cookbook

Installs Backuppc 4 (alpha 3) server

## Requirements

## Platforms

* Debian-family

### Dependencies

* apache2 `~> 1.9.6`
* build-essential `~> 1.4.4`
* perl `~> 1.2.2`
* postfix `~> 3.1.4`
* sudo `~> 2.5.2`

## Attributes

See the [default][] and [config][] attribute files for configuration variables
and their exlanation.

[default]: attributes/default.rb
[config]: attributes/config.rb

## Recipes

### Default

After setting the configuration variables, all that is left to do is to include
the default recipe:

```ruby
include_recipe 'backuppc-server::default'
```

You can visit the GUI on the `/` top level path.

# License and Author

Author:: Jean Mertz (<jean@mertz.fm>)

Copyright 2014, Kabisa ICT

Licensed under the MIT License (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://opensource.org/licenses/MIT

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
