#!/bin/sh

############################################################################################
#
# Copy and unpack project zip to a host that can access hadoop and run the install script
# from that host to submit the workflow.
#
############################################################################################

set -x # enable shell debug output
set -e # exit on failed command
set -u # don't allow undefined variables.

mvn clean install -DskipTests

# Initialize default values
PROJECT_NAME="oozie-yarn-memory-problem"
HDFS_JOB_PATH=/user/${USER}/${PROJECT_NAME}
# Folder on ENV host to which to copy archive.
TARGET_FOLDER=${PROJECT_NAME}

#
# Read cmd line options
#
while getopts "h:o:n:j:m:" OPTION
do
  case $OPTION in
    h)  TARGET_HOST=$OPTARG;;      # The target host from which to run the install script.
    o)  OOZIE_URL=$OPTARG;;        # The oozie url
    n)  NAMENODE=$OPTARG;;         # The hdfs name node
    j)  JOB_TRACKER=$OPTARG;;      # Yarn job tracker
    m)  MEM_USAGE_FACTOR=$OPTARG;; # Memory usage factor
    \?) exit 1;;
  esac
done

ENV=${USER}@${TARGET_HOST}

ARCHIVE_NAME=`cd target;ls *.zip`

ssh -t $ENV "rm -rf ${TARGET_FOLDER};
             mkdir ${TARGET_FOLDER}"

# deploy the artifact
scp target/${ARCHIVE_NAME} $ENV:

ssh -t $ENV "unzip ${ARCHIVE_NAME} -d ${TARGET_FOLDER};
             cd ${TARGET_FOLDER};
             echo '' > empty.job.properties;
             ./install.sh -c empty.job.properties -d ${HDFS_JOB_PATH} -o ${OOZIE_URL} -n ${NAMENODE} -j ${JOB_TRACKER} -m ${MEM_USAGE_FACTOR}"


