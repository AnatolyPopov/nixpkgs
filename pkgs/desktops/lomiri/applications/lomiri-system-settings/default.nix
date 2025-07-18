{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  accountsservice,
  biometryd,
  cmake,
  cmake-extras,
  dbus,
  deviceinfo,
  geonames,
  gettext,
  glib,
  gnome-desktop,
  gsettings-qt,
  gtk3,
  icu75,
  intltool,
  json-glib,
  libqofono,
  libqtdbustest,
  libqtdbusmock,
  lomiri-content-hub,
  lomiri-indicator-datetime,
  lomiri-indicator-network,
  lomiri-schemas,
  lomiri-settings-components,
  lomiri-ui-toolkit,
  maliit-keyboard,
  mesa,
  pkg-config,
  polkit,
  python3,
  qmenumodel,
  qtbase,
  qtdeclarative,
  qtmultimedia,
  trust-store,
  ubports-click,
  upower,
  validatePkgConfig,
  wrapGAppsHook3,
  wrapQtAppsHook,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-system-settings-unwrapped";
  version = "1.3.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-system-settings";
    tag = finalAttrs.version;
    hash = "sha256-bVBxJgOy1eXqwzcgBRUTlFoJxxw9I1Qc+Wn92U0QzA4=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    ./2000-Support-wrapping-for-Nixpkgs.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}" \

    # Port from lomiri-keyboard to maliit-keyboard
    substituteInPlace plugins/language/{PageComponent,SpellChecking,ThemeValues}.qml plugins/language/onscreenkeyboard-plugin.cpp plugins/sound/PageComponent.qml \
      --replace-fail 'com.lomiri.keyboard.maliit' 'org.maliit.keyboard.maliit'

    # Gets list of available localisations from current system, but later drops any language that doesn't cover LSS
    # So just give it its own prefix
    substituteInPlace plugins/language/language-plugin.cpp \
      --replace-fail '/usr/share/locale' '${placeholder "out"}/share/locale'

    # Decide which entries should be visible based on the current system
    substituteInPlace plugins/*/*.settings \
      --replace-warn '/etc' '/run/current-system/sw/etc'

    # Don't use absolute paths in desktop file
    substituteInPlace lomiri-system-settings.desktop.in.in \
      --replace-fail 'Icon=@SETTINGS_SHARE_DIR@/system-settings.svg' 'Icon=lomiri-system-settings' \
      --replace-fail 'X-Lomiri-Splash-Image=@SETTINGS_SHARE_DIR@/system-settings-app-splash.svg' 'X-Lomiri-Splash-Image=lomiri-app-launch/splash/lomiri-system-settings.svg' \
      --replace-fail 'X-Screenshot=@SETTINGS_SHARE_DIR@/screenshot.png' 'X-Screenshot=lomiri-app-launch/screenshot/lomiri-system-settings.png'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    gettext
    glib # glib-compile-schemas
    intltool
    pkg-config
    qtdeclarative
    validatePkgConfig
  ];

  buildInputs = [
    accountsservice
    cmake-extras
    deviceinfo
    geonames
    gnome-desktop
    gsettings-qt
    gtk3
    icu75
    json-glib
    polkit
    qtbase
    trust-store
    ubports-click
    upower
  ];

  # QML components and schemas the wrapper needs
  propagatedBuildInputs = [
    biometryd
    libqofono
    lomiri-content-hub
    lomiri-indicator-datetime
    lomiri-indicator-network
    lomiri-schemas
    lomiri-settings-components
    lomiri-ui-toolkit
    maliit-keyboard
    qmenumodel
    qtdeclarative
    qtmultimedia
  ];

  nativeCheckInputs = [
    dbus
    mesa.llvmpipeHook # ShapeMaterial needs an OpenGL context: https://gitlab.com/ubports/development/core/lomiri-ui-toolkit/-/issues/35
    (python3.withPackages (ps: with ps; [ python-dbusmock ]))
    xvfb-run
  ];

  checkInputs = [
    libqtdbustest
    libqtdbusmock
  ];

  # Not wrapping in this derivation
  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_LIBDEVICEINFO" true)
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeFeature "LOMIRI_KEYBOARD_PLUGIN_PATH" "${lib.getLib maliit-keyboard}/lib/maliit/keyboard2/languages")
  ];

  # The linking for this normally ignores missing symbols, which is inconvenient for figuring out why subpages may be
  # failing to load their library modules. Force it to report them at linktime instead of runtime.
  env.NIX_LDFLAGS = "--unresolved-symbols=report-all";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Parallelism breaks D-Bus tests
  enableParallelChecking = false;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
    export QML2_IMPORT_PATH=${
      lib.makeSearchPathOutput "bin" qtbase.qtQmlPrefix (
        [
          qtdeclarative
          lomiri-ui-toolkit
          lomiri-settings-components
        ]
        ++ lomiri-ui-toolkit.propagatedBuildInputs
      )
    }
  '';

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas

    mkdir -p $out/share/{icons/hicolor/scalable/apps,lomiri-app-launch/{splash,screenshot}}

    ln -s $out/share/lomiri-system-settings/system-settings.svg $out/share/icons/hicolor/scalable/apps/lomiri-system-settings.svg
    ln -s $out/share/lomiri-system-settings/system-settings-app-splash.svg $out/share/lomiri-app-launch/splash/lomiri-system-settings.svg
    ln -s $out/share/lomiri-system-settings/screenshot.png $out/share/lomiri-app-launch/screenshot/lomiri-system-settings.png
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "System Settings application for Lomiri";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-system-settings";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-system-settings/-/blob/${
      if (!builtins.isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = licenses.gpl3Only;
    mainProgram = "lomiri-system-settings";
    teams = [ teams.lomiri ];
    platforms = platforms.linux;
    pkgConfigModules = [ "LomiriSystemSettings" ];
  };
})
