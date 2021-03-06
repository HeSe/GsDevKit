"Load and run tests to be performed by TravisCI"
| gitCache gitPath |
Transcript cr; show: 'travis---->travisCI.st'.

(MCWorkingCopy allManagers 
  collect: [ :wc | wc ancestors first name ]) sorted 
    do: [:packageName |
      Transcript cr; show: packageName].

"include the recommended GsUpgrader call"
Gofer new
  package: 'GsUpgrader-Core';
  url: 'http://ss3.gemtalksystems.com/ss/gsUpgrader';
  load.
(Smalltalk at: #GsUpgrader) upgradeGrease.

gitCache := 'git_cache'.
gitPath := (FileDirectory default directoryNamed: gitCache ) fullName.

GsDeployer deploy: [
  "Load the GsDevKit baseline"
  Metacello new
    baseline: 'GsDevKit';
    repository: 'filetree://', gitPath, '/GsDevKit/repository';
    get.
  Metacello new
    baseline: 'GsDevKit';
    repository: 'filetree://', gitPath, '/GsDevKit/repository';
    onLock: [:ex | ex honor];
    load: #( 'CI') ].

"Run the GsDevKit tests"
MetacelloPlatform current authorName: 'testMonkey'. "These tests save code ... need an Author"

Transcript cr; show: '---Start running tests...'.

[
TravisCIHarness
  value: #( 'BaselineOfGsDevKit' )
  value: 'TravisCISuccess.txt' 
  value: 'TravisCIFailure.txt'.
]
        on: Deprecation
        do: [ :ex |
            "catch and throw Error ..."
            true ifTrue: [nil error: 'DEPRECATION WARNNG: ', ex description printString ].
            "help for debugging Deprecation warnings"
            Transcript
                cr;
                show: '***Deprecation***************************************************';
                cr;
                show: ex description.
            (ex signalerContext stackOfSize: 100)
                do: [ :item | 
                    Transcript
                        cr;
                        show: item printString asString.
                    item tempScopedNames
                        doWithIndex: [ :title :index | 
                            Transcript
                                cr;
                                tab;
                                nextPutAll: title;
                                nextPut: $:;
                                space;
                                tab;
                                nextPutAll: (item tempAt: index) printString ].
                    Transcript
                        cr;
                        show: '***************************************************' ].
            ex resume].

