# kernel

- CPU性能模式

  ```
     Location:                                                                       │   
    │     -> Power management and ACPI options                                       │   
    │       -> CPU Frequency scaling                                                 │   
    │         -> CPU Frequency scaling (CPU_FREQ [=y])                               │   
    │           -> Default CPUFreq governor (<choice> [=n])
  ```

   ```
   Location:                                                                          │   
     │     -> Binary Emulations                                                       │   
     │       -> x32 ABI for 64-bit mode (X86_X32_ABI [=y])                            |
   ```

  

- 低延迟桌面

  ```
  Location:                                                                          │   
    │     -> General setup                                                           │   
    │       -> Preemption Model (<choice> [=n])                                      │   
    │         -> Preemptible Kernel (Low-Latency Desktop) (PREEMPT [=y]              |
  ```

  

- FQ-PIE

  ```
   Location:                                               			     	       │   
    │     -> Networking support (NET [=y])                    	           		   │   
    │       -> Networking options                                                    │   
    │         -> QoS and/or fair queueing (NET_SCHED [=y])                           │   
    │           -> Proportional Integral controller Enhanced (PIE) scheduler (NET_SC │   
    │             -> Flow Queue Proportional Integral controller Enhanced (FQ-PIE) ( │                                                                           
  ```

  ```
  lsmod | grep bbr：检查是否已加载BBR模块(如编译到内核，则无输出)。
  sysctl net.ipv4.tcp_available_congestion_control：检查可用的拥塞控制算法，是否包含"bbr"。
  sysctl net.ipv4.tcp_congestion_control：检查当前的拥塞控制算法是否为"bbr"。
  sysctl net.core.default_qdisc：检查默认的队列规则是否为"fq-pie"。
  ```

  