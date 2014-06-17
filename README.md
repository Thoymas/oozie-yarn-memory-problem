oozie-yarn-memory-problem
=========================

A project for reproducing a memory problem when using an oozie shell action

From the project root, run

```
src/test/scripts/runTest.sh -h <target-host> -o <oozie-url> -n <name-node> -j <job-tracker> -m <memory-factor>
```

This will make the test artifact zip, upload it to <target-host>, run the install.sh script from the <target-host> which
will submit the oozie workflow. The <memory-factor> controls how much memory the test script called from the oozie shell action
should consume. See src/main/scripts/run.sh


