# Ahoy!

Ahoy is a lightweight javascript library that tracks how visitors arrive at your website.

### Like Google Analytics?

Similar, except you see how specific visitors arrived at your site. You can then measure how each visitor performs __over time - not just the first visit__ - and compare sources on:

- monthly revenue
- sign ups
- length of time before upgrading

and any other metrics you desire.

### How does it work?

Ahoy turns an ugly HTTP `Referer` header like

```
http://www.google.com/url?sa=t&source=web&cd=2&ved=0CCsQFjAB&rct=j&q=test...
```

into a cookie named `ahoy` that looks like

```javascript
{
  "site":         "google.com",
  "category":     "search",
  "info":         "query > parrots",
  "referrer":     "http://www.google.com/url...",
  "arrived_at":   "Mon May 09 2011 19:08:45 GMT-0700 (PDT)"
}
```

When a user signs up, you can read the cookie, parse the JSON, and save it to the database.

### Rails

```ruby
source = JSON.parse(cookies["ahoy"])
```

### PHP

```php
$source = parse_json($_COOKIES["ahoy"]);
```

Super simple! Ahoy works with any language that can read cookies and parse JSON.

# Install

1. Download the latest version.

  - [Production (4KB minified)](https://github.com/ankane/ahoy/raw/master/releases/ahoy-0.1.3.min.js)
  - [Development](https://github.com/ankane/ahoy/raw/master/releases/ahoy-0.1.3.js)

2. Add the following code right before the `</body>` tag.

```html
<script type="text/javascript" src="ahoy-0.1.3.min.js"></script>
<script type="text/javascript">
ahoy.matey();
</script>
```

# Customize

Ahoy was built to be highly customizable.  Here are a few things you can do.

```html
<script type="text/javascript">
// change the cookie name
ahoy.cookieName("trafficSource");

// fire callback when a visitor first arrives
ahoy.onArrival( function(source) {
  console.log(source);
});

// add a custom host so traffic arriving from
// news.ycombinator.com appears as "hackernews"
ahoy.addHost("news.ycombinator.com", function() {
  return {"site": "hackernews", "category": "news"};
});

// call this last
ahoy.matey();
</script>
```

# Contribute

Ahoy is written in CoffeeScript. Please report bugs on the [GitHub issue tracker](https://github.com/ankane/ahoy/issues).

If you would like to contribute, first clone the repository.

```
git@github.com:ankane/ahoy.git
cd ahoy
```

Build and test the library

```
cake build && cake spec
```
