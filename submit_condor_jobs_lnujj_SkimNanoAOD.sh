#!/bin/bash
echo "Starting job on " `date`
echo "Running on: `uname -a`"
echo "System software: `cat /etc/redhat-release`"
source /cvmfs/cms.cern.ch/cmsset_default.sh
echo "copy cmssw tar file from store area"
cp -s ${3}/CMSSW_13_3_3.tgz  .
tar -xf CMSSW_13_3_3.tgz
rm CMSSW_13_3_3.tgz
cd CMSSW_13_3_3/src/PhysicsTools/NanoAODTools/python/postprocessing/analysis/nanoAOD_skim/
rm *.root
scramv1 b ProjectRename
eval `scram runtime -sh`
echo "========================================="
echo "cat post_proc.py"
echo "..."
cat post_proc.py
echo "..."
echo "========================================="
python3 post_proc.py --entriesToRun 0  --inputFile ${1} 
echo "====> List root files : " 
ls *.root
echo "====> copying *.root file to stores area..." 
if ls skimmed_nano.root 1> /dev/null 2>&1; then
    echo "File skimmed_nano.root exists. Copy this."
    echo "cp skimmed_nano.root ${2}/${4}_Skim.root"
    cp  skimmed_nano.root ${2}/${4}_Skim.root
else
    echo "file skimmed_nano.root does not exists, so copy *.root file."
    echo "cp *.root ${2}/${4}_Skim.root"
    cp  *.root ${2}/${4}_Skim.root
fi
rm *.root
cd ${_CONDOR_SCRATCH_DIR}
rm -rf CMSSW_13_3_3
