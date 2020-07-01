m_net_def variable expects a map object like following:
```buildoutcfg
m_net_def = public_nets
```

```
public_nets = {
  public_net_1 : {
    cidr = "10.13.1.0/24"
    avz  = "avz1"
  },
  public_net_2 : {
    cidr = "10.13.2.0/24"
    avz  = "avz2"
  }
}
```

then module iterates over public_nets' keys and used uses its values to as paramaters for new network.
