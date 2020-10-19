
## Master Logs

```
KubeEvents
| where ClusterId =~ '/subscriptions/.../resourceGroups/.../providers/Microsoft.RedHatOpenShift/OpenShiftClusters/...'
| where Computer contains "master"
| project TimeGenerated, Name, ObjectKind, KubeEventType, Reason, Message, Namespace, Computer, SourceComponent
| order by TimeGenerated desc
```
