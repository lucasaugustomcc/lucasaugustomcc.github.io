#!/bin/bash
#
# RO manager sample script.
# Run this from the "$RO_MANAGER/src/samples" directory.
#

ROBASE="robase"

echo "--------"

mkdir -p $ROBASE

ro config -v \
  -b $ROBASE \
  -r http://sandbox.wf4ever-project.org/rodl/ROs/ \
  -t "47d5423c-b507-4e1c-8" \
  -n "Lucas" \
  -e "lucas.carvalho@ic.unicamp.br"

echo "--------"

mkdir  $ROBASE/test-create-RO

rm -rf $ROBASE/test-create-RO/.ro
cp -r  RO-example/* $ROBASE/test-create-RO

ro create -v "Reproducible WRO" -d $ROBASE/test-create-RO -i RO-id-testCreate

ro add -v -a -d $ROBASE/test-create-RO $ROBASE/test-create-RO

ro status -v -d $ROBASE/test-create-RO

ro list -v -d $ROBASE/test-create-RO

ro list -v -a -d $ROBASE/test-create-RO

echo "--------"

ro annotate -v $ROBASE/test-create-RO/build/structure.pdb title "​crystal ​structure​ of the protein"
ro annotate -v $ROBASE/test-create-RO/build/water.pdb title "coordinates of water molecules present in the crystal structure"
ro annotate -v $ROBASE/test-create-RO/build/protein.pdb title "coordinates of the protein atoms​"
ro annotate -v $ROBASE/test-create-RO/build/cal.pdb title "coordinates of calcium ions present in the crystal structure"

ro annotate -v $ROBASE/test-create-RO/toppar/par_all22_prot.prm title "force field parameters for protein​s"
ro annotate -v $ROBASE/test-create-RO/toppar/par_all36_carb.prm title "​force field parameters for carbohydrates"


ro annotate -v $ROBASE/test-create-RO/toppar/pca.prm title "force field parameter for the non-standard residue PCA"
ro annotate -v $ROBASE/test-create-RO/toppar/pca.rtf title "​topology file for ​the non-standard residue PCA"

ro annotate -v $ROBASE/test-create-RO/toppar/top_all36_prot.rtf title "topology file for protein​s"
ro annotate -v $ROBASE/test-create-RO/toppar/top_all36_carb.rtf title "​topology file for carbohydrates​"


ro annotate -v $ROBASE/test-create-RO/build/hyd.pdb title "crystal structure with hydrogen atoms added​"
ro annotate -v $ROBASE/test-create-RO/build/hyd.psf title "​structure file for the crystal structure with hydrogen atoms added​"

ro annotate -v $ROBASE/test-create-RO/build/wbox.pdb title "​coordinates of the solvated system"
ro annotate -v $ROBASE/test-create-RO/build/wbox.psf title "​structure file of the solvated system"

ro annotate -v $ROBASE/test-create-RO/build/bglc.pdb title "coordinates of the glucan chain present in the crystal structure"
ro annotate -v $ROBASE/test-create-RO/build/bglc.psf title "structure file for the glucan chain"

ro annotate -v $ROBASE/test-create-RO/build/cbh1.pdb title "​initial coordinates for the simulations, containing protein, water, ions and glucan chain"
ro annotate -v $ROBASE/test-create-RO/build/cbh1.psf title "structure file for the coordinate file cbh1.pdb"

ro annotate -v $ROBASE/test-create-RO/build/fixed.1.pdb title "coordinates for the whole system (cbh1.pdb), indicating which atoms should be kept fixed along the simulation"
ro annotate -v $ROBASE/test-create-RO/build/fixed.2.pdb title "coordinates for the whole system (cbh1.pdb), indicating which atoms should be kept fixed along the simulation​"

ro annotate -v $ROBASE/test-create-RO/md1/dynamics-1.namd title "​input for MD simulation​ -- production runs, after equilibration steps below"
ro annotate -v $ROBASE/test-create-RO/md1/equilibration-1.namd title "​input for MD simulation, with fixed atoms indicated by the file fixed.1.pdb​"
ro annotate -v $ROBASE/test-create-RO/md1/equilibration-2.namd title "​input for MD simulation​, with fixed atoms indicated by the file fixed.​2​.pdb"
ro annotate -v $ROBASE/test-create-RO/md1/equilibration-3.namd title "​input for MD simulation​, with all atoms free"

ro annotate -v $ROBASE/test-create-RO/md1/output/distance title "​program to compute distance between pairs of atoms​"
ro annotate -v $ROBASE/test-create-RO/md1/output/distance.dat title "​distance between atoms in function of the simulation time​"
ro annotate -v $ROBASE/test-create-RO/md1/output/distance.inp title "​input for the program distance​"
ro annotate -v $ROBASE/test-create-RO/md1/output/README title "​README​"
ro annotate -v $ROBASE/test-create-RO/md1/output/trajectory.dcd title "​output of the MD simulation: xyz coordinates of the protein in function of the time​"
ro annotate -v $ROBASE/test-create-RO/md1/output/trajectory.psf title "​structure file to the output of the MD simulation​"

ro annotate -v $ROBASE/test-create-RO/workflow/executable-workflow.t2flow title "initial workflow"
ro annotate -v $ROBASE/test-create-RO/workflow/refined-workflow.t2flow title "refined workflow"
ro annotate -v $ROBASE/test-create-RO/provenance/executable-workflow.provenance.bundle.zip title "provenance traces bundle exported by Taverna from execution of the initial workflow"
ro annotate -v $ROBASE/test-create-RO/provenance/refined-workflow.provenance.bundle.zip title "provenance traces bundle exported by Taverna from execution of the refined workflow"

ro annotate -v $ROBASE/test-create-RO/build/build.sh title "original MD shell script"

ro annotate -v $ROBASE/test-create-RO/yesworkflow/abstract-workflow.png title "abstract workflow derived from the script"

ro annotate -v $ROBASE/test-create-RO/provenance/script-workflow.prov.ttl title "PROV statements defining derivation of the workflow from script"

ro annotations -v -d $ROBASE/test-create-RO

ro list -v -a -d $ROBASE/test-create-RO

echo "--------"

# End.
