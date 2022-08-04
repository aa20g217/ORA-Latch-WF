"""
Over-Representation (or Enrichment) Analysis.
"""


import subprocess
from pathlib import Path

from flytekit import LaunchPlan, task, workflow
from latch.types import LatchDir,LatchFile

@task
def runScript(inputDir: LatchFile,output_dir: LatchDir,org: str="human",threshold: str="0.1") -> LatchDir:

    subprocess.run(
        [
            "Rscript",
            "knit.R",
            inputDir.local_path,
            org,
            threshold
        ]
    )

    local_output_dir = str(Path("/root/results").resolve())

    remote_path=output_dir.remote_path
    if remote_path[-1] != "/":
        remote_path += "/"

    return LatchDir(local_output_dir,remote_path)


@workflow
def ora_wf(inputDir: LatchFile,output_dir: LatchDir,org: str="human",threshold: str="0.1") -> LatchDir:
    """

    Over Representation Analysis (ORA)
    ----

    `Over Representation Analysis (ORA)` is a widely used approach to determine whether known biological functions or processes are over-represented (= enriched) in an experimentally-derived gene list, e.g. a list of differentially expressed genes (DEGs).


    __metadata__:
        display_name: ORA
        author:
            name: Akshay
            email: akshaysuhag2511@gmail.com
            github:
        repository:
        license:
            id: MIT

    Args:

        inputDir:
          Select input file(.csv).

          __metadata__:
            display_name: Input File

        org:
          Possible options: human, rat and mouse.

          __metadata__:
            display_name: organism

        threshold:
          	Cutoff value of pvalue and q value (between 0 to 1).

          __metadata__:
            display_name: Threshold

        output_dir:
          Where to save the report and plots?.

          __metadata__:
            display_name: Output Directory
    """
    return runScript(inputDir=inputDir,org=org,threshold=threshold,output_dir=output_dir)
