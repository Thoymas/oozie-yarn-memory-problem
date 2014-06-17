#!/bin/sh

set -x # enable shell debug output
set -e # exit on failed command
set -u # don't allow undefined variables.

#
# Read cmd line options
#
while getopts "o:d:c:n:j:m:" OPTION
do
  case $OPTION in
    o)  OOZIE_URL=$OPTARG;;       # The oozie url
    d)  HDFS_JOB_PATH=$OPTARG;;   # The hdfs destination of the workflow
    c)  CONFIG_PATH=$OPTARG;;     # The path to the oozie job properties file
    n)  NAMENODE=$OPTARG;;        # The hdfs name node
    j)  JOB_TRACKER=$OPTARG;;     # Yarn job tracker
    m)  MEM_USE_FACTOR=$OPTARG;;  # Controls amount of memory the run.sh script should use
    \?) exit 1;;
  esac
done

#
# Copy job files to hdfs
#

hadoop fs -rm -r ${HDFS_JOB_PATH}
hadoop fs -mkdir ${HDFS_JOB_PATH}
hadoop fs -copyFromLocal ./* ${HDFS_JOB_PATH}

#
# Submit Oozie job
#
JOB_RESULT=$(oozie job -D oozie.wf.application.path=${NAMENODE}${HDFS_JOB_PATH} \
                       -D nameNode=${NAMENODE} \
                       -D jobTracker=${JOB_TRACKER} \
                       -D memUseFactor=${MEM_USE_FACTOR} \
                       -oozie ${OOZIE_URL} -config ${CONFIG_PATH} -run)

JOBID=`echo ${JOB_RESULT} | sed 's/job: \(.*\)/\1/'`


oozie job -oozie ${OOZIE_URL} -info ${JOBID}