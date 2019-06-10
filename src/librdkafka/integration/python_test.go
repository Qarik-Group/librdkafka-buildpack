package integration_test

import (
	"path/filepath"

	"github.com/cloudfoundry/libbuildpack/cutlass"

	. "github.com/onsi/ginkgo"
	. "github.com/onsi/gomega"
)

var _ = Describe("Python Integration Test", func() {
	var app *cutlass.App
	AfterEach(func() {
		if app != nil {
			// app.Destroy()
		}
		app = nil
	})

	It("app deploys", func() {
		app = cutlass.New(filepath.Join(bpDir, "fixtures", "py-sample"))
		app.Buildpacks = []string{"librdkafka_buildpack", "python_buildpack"}
		PushAppAndConfirm(app)
		Expect(app.GetBody("/")).To(ContainSubstring("Something on your website"))
	})
})
