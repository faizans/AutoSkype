all: clean
	@echo "Build started.."
	osacompile -o AutoSkype.app -x AutoSkype.applescript
	@echo "Build finished."

clean:
	@echo "Cleaning up.."
	rm -rf *.app/
