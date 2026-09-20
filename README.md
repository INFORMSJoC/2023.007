<p align="center">
  <img src="https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg"
       alt="INFORMS Journal on Computing"
       width="900">
</p>

# On-the-fly: An Efficient Online Tucker Decomposition for Tensor Streams

This archive is distributed in association with the
[INFORMS Journal on Computing](https://pubsonline.informs.org/journal/ijoc)
under the [MIT License](https://github.com/INFORMSJoC/2023.007/blob/main/LICENSE).

The software and data in this repository are a snapshot of the code and data used
in the research reported in the paper
"On-the-fly: An Efficient Online Tucker Decomposition for Tensor Streams"
by Houping Xiao, Kai Zhao, and Arun Rai.

## Cite

To cite the contents of this repository, please cite both the paper and this repo,
using their respective DOIs.

Repository:

https://doi.org/10.1287/ijoc.2023.007

Repository DOI:

https://doi.org/10.1287/ijoc.2023.007.cd

Below is the BibTeX for citing this snapshot of the repository.

```bibtex
@misc{xiao2026,
  author =     {Xiao, Houping and Zhao, Kai and Rai, Arun},
  publisher =  {INFORMS Journal on Computing},
  title =      {On-the-fly: An Efficient Online Tucker Decomposition for Tensor Streams},
  year =       {2026},
  doi =        {10.1287/ijoc.2023.007.cd},
  note =       {Available for download at https://github.com/INFORMSJoC/2023.007},
}
```

## Description

This repository contains the MATLAB implementation of the Online Tucker
Decomposition (OTD) framework and the baseline methods used in the paper.

The baseline methods include conventional Tucker decomposition methods, matrix
factorization approaches, and neural-network-based autoencoder methods.

The experiments compare OTD with these baselines using both synthetic and
benchmark datasets. The Columbia Object Image Library (COIL) datasets are used
in the main paper, while MNIST and CIFAR-10 are included as additional benchmark
datasets in the Online Supplement.

## Repository Structure

The repository is organized as follows:

- `src/`: MATLAB source code for OTD and baseline methods.
- `data/`: datasets and dataset documentation used in the experiments.
- `Results/`: experimental outputs and figures.
- `README.md`: overview of the repository and instructions for reproducing the experiments.
- `AUTHORS`: list of authors associated with this software archive.
- `LICENSE`: licensing information for the source code.

Additional README files may be included within individual directories to provide
more specific instructions.

## Software Requirements

The experiments were implemented in MATLAB.

Before running the code, the MATLAB Tensor Toolbox should be installed and added
to the MATLAB path. The experiments used:

- MATLAB
- Tensor Toolbox v3.2.1

The Tensor Toolbox should be added to the MATLAB path before running the
experiments. For example:

```matlab
addpath path/to/tensor_toolbox-v3.2.1
```

Replace `path/to/tensor_toolbox-v3.2.1` with the location of the Tensor Toolbox
on your computer.

## Data

The repository includes data and/or documentation for the datasets used in the
experiments.

The real-world benchmark datasets include:

- Columbia Object Image Library (COIL)
- MNIST
- CIFAR-10

The COIL datasets are used in the main paper. MNIST and CIFAR-10 are used as
additional benchmark datasets in the Online Supplement.

Please refer to `data/README.md` for dataset descriptions, original sources,
citations, and applicable licensing information.

Third-party datasets remain subject to their original licenses and terms of use.

## Running the Experiments

Before running the experiments:

1. Install MATLAB.
2. Install Tensor Toolbox v3.2.1.
3. Add the Tensor Toolbox directory to the MATLAB path.
4. Download or prepare the required datasets as described in `data/README.md`.
5. Navigate to the appropriate directory under `src/`.
6. Run the corresponding MATLAB scripts for the desired experiment.

The code reproduces the main categories of experiments reported in the paper,
including:

- synthetic tensor-stream experiments;
- comparisons under different tensor-growth settings;
- comparisons under different tensor-rank settings;
- experiments using COIL datasets;
- supplementary experiments using MNIST and CIFAR-10; and
- comparisons with Tucker decomposition, matrix factorization, and
  autoencoder-based baseline methods.

Please refer to the README files and comments within `src/` for the specific
scripts corresponding to each experiment.

## Results

Experimental outputs and figures are stored in the `Results/` directory.

The reported results include reconstruction error and running time comparisons
between OTD and the baseline methods. Additional analyses reported in the paper
and Online Supplement examine representation quality, tensor-rank settings, and
performance across benchmark datasets.

## License

The source code in this repository is distributed under the MIT License.

See the [LICENSE](https://github.com/INFORMSJoC/2023.007/blob/main/LICENSE)
file for details.

Third-party datasets included in or referenced by this repository remain subject
to their original licenses, copyrights, and terms of use.

## Authors

The authors associated with this repository are:

- Houping Xiao
- Kai Zhao
- Arun Rai

See the [AUTHORS](https://github.com/INFORMSJoC/2023.007/blob/main/AUTHORS)
file for contact information.
