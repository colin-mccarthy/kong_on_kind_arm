# kong_on_kind_arm


##port forwarding...

```
kubectl -n kong port-forward --address localhost,0.0.0.0 svc/kong-proxy 8080:80
```

```
curl localhost:8080
{"message":"no Route matched with those values"}%  
```


##Trying to get it to work without port forwarding...

```
kubectl patch deployment -n kong ingress-kong -p '{"spec":{"template":{"spec":{"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'


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
