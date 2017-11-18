package supply

import "github.com/cloudfoundry/libbuildpack"

type Manifest interface {
	DefaultVersion(string) (libbuildpack.Dependency, error)
	InstallDependency(libbuildpack.Dependency, string) error
}

type Stager interface {
	AddBinDependencyLink(string, string) error
	DepDir() string
}

type Supplier struct {
	Stager   Stager
	Manifest Manifest
	Log      *libbuildpack.Logger
}

func Run(ss *Supplier) error {
	if err := ss.Installlibrdkafka(); err != nil {
		ss.Log.Error("Unable to install librdkafka: %s", err.Error())
		return err
	}

	return nil
}

func (ss *Supplier) Installlibrdkafka() error {
	ss.Log.BeginStep("Installing librdkafka")

	librdkafka, err := ss.Manifest.DefaultVersion("librdkafka")
	if err != nil {
		return err
	}
	ss.Log.Info("Using librdkafka version %s", librdkafka.Version)

	if err := ss.Manifest.InstallDependency(librdkafka, ss.Stager.DepDir()); err != nil {
		return err
	}
	return nil
}
