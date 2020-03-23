# Azure Active Directory Authentication

## 1. Add Optional UPN Claim

## 2. Create an OpenShift secret for the Service Principal Secret

```bash
oc create secret generic openid-client-secret-aad \
    --from-literal=clientSecret=<YOUR_CLIENT_SECRET> \
    --namespace openshift-config
```

## 3. Add your cluster's OAuth Callback URL to Active Directory

`https://oauth-openshift.apps.15owzrxf.eastus.aroapp.io/oauth2callback/AAD`

```bash
az ad app update --id $CLIENT_ID --reply-urls $CALLBACK_URL
```

> **Note:** If you created a separate SSO Service Principal in a different Azure AD Tenant than the cluster service principal then you will need to update the reply URL manually through the portal.

## 4. Add the OpenID Connect configuration to your cluster

```yaml
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
  - name: AAD
    mappingMethod: claim
    type: OpenID
    openID:
      clientID: <YOUR_CLIENT_ID>
      clientSecret: 
        name: openid-client-secret-aad 
      extraScopes: 
      - email
      - profile
      extraAuthorizeParameters: 
        include_granted_scopes: "true"
      claims:
        preferredUsername: 
        - email
        - upn
        name: 
        - name
        email: 
        - email
      issuer: https://login.microsoftonline.com/<YOUR_TENANT_ID>
```

```bash
oc apply -f aad.yaml
```
