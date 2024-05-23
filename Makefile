-include .hostfi_env

# Config variables (can be overriden from environment or `.bloc_sample_env`)


help: ## This help dialog.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
	for help_line in $${help_lines[@]}; do \
			IFS=$$'#' ; \
			help_split=($$help_line) ; \
			help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			printf "%-30s %s\n" $$help_command $$help_info ; \
	done

fresh: ## Runs `clean`, `codegen-build`, and `generate-intl` for a fresh setup.
	make codegen-root

clean: ## Cleans Flutter project.  dart run build_runner build --delete-conflicting-outputs
	rm -f pubspec.lock
	rm -f ios/Podfile.lock
	flutter clean
	flutter pub get
	cd ios && pod repo update && pod install && cd ..
	dart run build_runner build --delete-conflicting-outputs

codegen-root: ## Generate codegen files and do not watch for changes.
	(fvm flutter clean;flutter pub get;dart run build_runner build --delete-conflicting-outputs)

codegen-build: ## Generate codegen files and do not watch for changes.
	dart run build_runner build --delete-conflicting-outputs

codegen-watch: ## Generate codegen files and watch for changes.
	dart run build_runner watch --delete-conflicting-outputs

analyze: ## Runs `flutter analyze`.
	flutter analyze

test: ## Runs unit tests.
	flutter test
