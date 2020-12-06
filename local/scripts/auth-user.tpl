import hudson.security.FullControlOnceLoggedInAuthorizationStrategy
import hudson.security.HudsonPrivateSecurityRealm
import jenkins.model.Jenkins

def jenkins = Jenkins.get()
def realm = new HudsonPrivateSecurityRealm(false, false, null)

String user = '${JENKINS_AUTH_USER}'
String password = '${JENKINS_AUTH_PASSWORD}'

def account = realm.createAccount(user, password)
def authStrategy = new FullControlOnceLoggedInAuthorizationStrategy();
authStrategy.setAllowAnonymousRead(false)

println "==> Created user ${account}"

jenkins.setSecurityRealm(realm)
jenkins.setAuthorizationStrategy(authStrategy)
jenkins.save()
