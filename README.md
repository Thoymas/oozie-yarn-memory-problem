oozie-yarn-memory-problem
=========================

A project for reproducing a memory problem when using an oozie shell action.

The problem is the following:

We have a shell action in an oozie workflow that needs a different amount of memory than
what Yarn allows map tasks by default. In our test environment, this seems to be 4Gb. For this particular shell action we
need more memory, so we try to use the "mapreduce.map.memory.mb" configuration option to specify this. However, this seems to have
no effect. The job always seems to fail with an error message saying something like this

```
pid=1685,containerID=container_1402932298551_0100_01_000002] is running beyond physical memory limits.
Current usage: 4.1 GB of 4 GB physical memory used; 5.4 GB of 8.4 GB virtual memory used. Killing container.
```

To reproduce this, stand in the project root and run:

```
src/test/scripts/runTest.sh -h <target-host> -o <oozie-url> -n <name-node> -j <job-tracker> -m <memory-factor>
```

This will make the test artifact zip, upload it to \<target-host\>, run the install.sh script from the \<target-host\> which
will submit the oozie workflow. The \<memory-factor\> controls how much memory the test script called from the oozie shell action
should consume. See src/main/scripts/run.sh


