# kong_on_kind_arm

```
$ kubectl patch deployment -n kong ingress-kong -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"}}}} }'


kubectl -n kong get deployment ingress-kong -o=jsonpath="{.spec.template.spec.nodeSelector}"
```


Change service kong-proxy from  LoadBalancer to NodePort
```
k get svc -n kong
NAME                      TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
kong-proxy                LoadBalancer   10.96.143.88   <pending>     80:30827/TCP,443:32296/TCP   6m25s
kong-validation-webhook   ClusterIP      10.96.59.82    <none>        443/TCP                      6m25s

kubectl patch service -n kong kong-proxy --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]'
service/kong-proxy patched

k get svc -n kong                                                                                                    
NAME                      TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
kong-proxy                NodePort    10.96.143.88   <none>        80:30827/TCP,443:32296/TCP   6m46s
kong-validation-webhook   ClusterIP   10.96.59.82    <none>        443/TCP                      6m46s
```
