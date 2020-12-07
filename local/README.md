## How to get the list of plugins?

```groovy
Jenkins.get().pluginManager.plugins.each { 
  println "${it.getShortName()}:${it.getVersion()}"
}
```
