# Setup a VPN from inside a pod in Kubernetes to a remote client
<br>

<div align="center"><h2>General Info</h2></div>

### POD: 
	DNS: clientvpn.mydomain.com  > foo.elb.xx-zzz-n.amazonaws.com
	LAN: 192.168.1.18

### Client Info
	LAN: 10.0.100.50
	WAN: 54.129.53.100

<br>
<div align="center"><h2>Kubernetes cluster</h2></div>

### Apply deployment
	kubectl apply -f . 

### kubectl -n vpn get pod,svc
	NAME                                   READY   STATUS    RESTARTS   AGE
	pod/ipsec-vpn-server-7f8fb6b58-b8846   1/1     Running   0          14m
		
	NAME                               TYPE           CLUSTER-IP      EXTERNAL-IP                      PORT(S)                        AGE
	service/ipsec-vpn-server-aws-nlb   LoadBalancer   10.100.86.159   foo.elb.xx-zzz-n.amazonaws.com   500:31502/UDP,4500:30413/UDP   38m

<br>

<div align="center"><h2>Customer site</h2></div>

### Install and configure strongswan: 
	apt-get update; apt-get install strongswan -y 

### /etc/ipsec.conf
	config setup
	  strictcrlpolicy=no
	  uniqueids=yes
	  charondebug="all"
	conn base-config
	  authby=secret        
	  left=%defaultroute
	  leftid=54.129.53.100
	  leftsubnet=0.0.0.0/0
	  ike=aes256-sha1-modp1536 		# aes256-sha1-modp1536,aes128gcm16-aes128gcm12-aes128gcm8-sha256-modp3072-modp2048,aes128gcm16-aes128gcm12-aes128gcm8-sha1-modp3072-modp2048!,aes128-aes256-sha1-modp3072-modp2048,3des-sha1-md5-modp1024         
	  esp=aes256-sha1          		# aes256-sha1-modp1536,aes128gcm16-aes128gcm12-aes128gcm8-sha1-modp3072-modp2048!
	  keyingtries=%forever
	  leftauth=psk
	  rightauth=psk
	  keyexchange=ikev2
	  ikelifetime=10h
	  lifetime=8h
	  dpddelay=30
	  dpdtimeout=120
	  dpdaction=restart
	  auto=start
	conn vpn-client
	  also=base-config
	  right=clientvpn.mydomain.com
	  rightid=clientvpn.mydomain.com
	  rightsubnet=0.0.0.0/0


### /etc/ipsec.secrets
	%any  %any  : PSK "lutDg2Jnb3jIeGn8NM9IggY5hFLyG/n0d6sXClLm"

<br>

### Test connection in pod (kubectl -n vpn exec -it pod/ipsec-vpn-server-7f8fb6b58-b8846 -- bash)
	bash-5.1# ipsec restart
	Stopping strongSwan IPsec failed: starter is not running
	Starting strongSwan 5.9.1 IPsec [starter]...
	bash-5.1# ipsec status
	Security Associations (1 up, 0 connecting):
	  vpn-client[2]: ESTABLISHED 4 seconds ago, 192.168.1.18[clientvpn.mydomain.com]...54.129.53.100[54.129.53.100]
	  vpn-client{1}:  INSTALLED, TUNNEL, reqid 1, ESP in UDP SPIs: c36ac1d6_i cd77b6c1_o
	  vpn-client{1}:   54.130.49.150/32 === 0.0.0.0/0


### Connectivity test in pod (kubectl -n vpn exec -it pod/ipsec-vpn-server-7f8fb6b58-b8846 -- bash)
	bash-5.1# ping 10.0.100.50
	PING 10.0.100.50 (10.0.100.50): 56 data bytes
	64 bytes from 10.0.100.50: seq=0 ttl=64 time=0.944 ms
	64 bytes from 10.0.100.50: seq=1 ttl=64 time=0.846 ms
	64 bytes from 10.0.100.50: seq=2 ttl=64 time=0.899 ms



<br><br>


<div align="center"><h2>Acknowledgments and awards</h2>

<br>
	
### AWS [solutions case-studies]
<a href="https://aws.amazon.com/pt/solutions/case-studies/intraway/" target="_blank" ><img src="img/aws.jpeg" ></a>

<br>

### Cámara Argentina de Comercio y Servicios (CAC) -  [La Huella Podcast]
<a href="https://open.spotify.com/episode/6nWlsWajxamdcUYB5r7tdJ" target="_blank" ><img src="img/podcast.jpeg" width="250" height="300"></a>

</div> 

<br>
