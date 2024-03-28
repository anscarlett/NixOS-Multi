{ inputs, ... }:
{
  imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];

  home.file.".config/kate/lspclient/settings.json".text = ''
    {
      "servers": {
        "nix": {
          "command": ["nil"],
          "url": "https://github.com/oxalica/nil",
          "highlightingModeRegex": "^Nix$"
        }
      }
    }
  '';

  # rm .config/k* .config/plasma* .config/power*
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezetwilight.desktop"; # breezedark, breezetwilight
      # cursorTheme = "Bibata-Modern-Ice";
      # iconTheme = "Papirus-Dark";
      # colorScheme = "Genshin";
      # wallpaper = "${pkgs.libsForQt5.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images/1080x1920.png";
    };

    # 面板
    panels = [
      {
        location = "bottom";
        height = 44; # default value
        floating = true;
        widgets = [
          "org.kde.plasma.panelspacer" # 面板间隙
          "org.kde.plasma.kickoff"
          "org.kde.plasma.marginsseparator" # 边距分隔符
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General.launchers = [
                "applications:kitty.desktop"
                "applications:org.kde.dolphin.desktop"
                # "applications:org.kde.kate.desktop"
                # "applications:emacs.desktop"
                "applications:firefox.desktop"
                "applications:org.telegram.desktop.desktop"
              ];
            };
          }
          "org.kde.plasma.panelspacer" # 面板间隙
          "org.kde.plasma.marginsseparator" # 边距分隔符
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
          "org.kde.plasma.pager" # 虚拟桌面切换器
        ];
      }
      # {
      #   location = "top";
      #   height = 26;
      #   widgets = [
      #     "org.kde.plasma.appmenu"
      #   ];
      # }
    ]; # panels end here.

    configFile = {
      # 密码库
      "kwalletrc"."Wallet"."Enabled".value = false;
      "kwalletrc"."Wallet"."First Use".value = false;

      # 搜索
      "baloofilerc"."Basic Settings"."Indexing-Enabled".value = false;

      # dolphin
      "dolphinrc"."General"."ShowFullPath".value = true;

      # 剪贴板
      klipperrc = {
        "General"."MaxClipItems".value = 300;
        "General"."SyncClipboards".value = true;
      };

      # FIXME: https://github.com/pjones/plasma-manager/issues/47
      # kcminputrc = {
      #   "Libinput.1739.52804.MSFT0001:00 06CB:CE44 Touchpad"."NaturalScroll" = true;
      # };

      # 锁屏
      kscreenlockerrc = {
        "Daemon"."Timeout".value = 8; # minutes
      };

      # 电源管理
      # powermanagementprofilesrc = {
      #   "AC.DPMSControl".idleTime = 780; # 13 min
      #   "AC.DimDisplay".idleTime = 480000; # 8 min
      #   "AC.HandleButtonEvents" = {
      #     lidAction = 32;
      #     triggerLidActionWhenExternalMonitorPresent = false;
      #   };
      #   "AC.SuspendSession" = {
      #     idleTime = null;
      #     suspendThenHibernate = null;
      #     suspendType = null;
      #   };
      #   "Battery.DPMSControl".idleTime = 600; # 10 min
      #   "Battery.DimDisplay".idleTime = 300000; # 5 min
      #   "Battery.HandleButtonEvents".triggerLidActionWhenExternalMonitorPresent = false;
      #   "Battery.SuspendSession" = {
      #     idleTime = null;
      #     suspendThenHibernate = null;
      #     suspendType = null;
      #   };
      #   "LowBattery.SuspendSession".suspendThenHibernate = false;
      # }; #### powermanagement end here.

      kwinrc = {
        # 窗口管理 - 虚拟桌面
        "Desktops"."Rows".value = 2;
        "Desktops"."Number".value = 4;
        "Desktops"."Name_1".value = "one";
        "Desktops"."Name_2".value = "two";
        "Desktops"."Name_3".value = "three";
        "Desktops"."Name_4".value = "four";

        # 夜间颜色
        "NightColor"."Active".value = true;
        "NightColor"."Mode".value = "Location";
        "NightColor"."LatitudeFixed".value = 23.12;
        "NightColor"."LongitudeFixed".value = 113.26;
        "NightColor"."NightTemperature".value = 3800;

        "Wayland"."InputMethod[$e]".value = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";

        # 窗口管理 - 桌面特效
        Plugins = {
          wobblywindowsEnabled.value = true;
          cubeEnabled.value = true;
          # blurEnabled = false;
          # contrastEnabled = true;
          # kwin4_effect_squashEnabled = false;
          # magiclampEnabled = true;
          # zoomEnabled = false;
        };

        # 窗口管理 - 任务切换器
        TabBox = {
          LayoutName.value = "big_icons";
          # HighlightWindows = false;
        };

        # Windows = {

        # };

        # 颜色和主题 - 窗口装饰元素
        "org.kde.kdecoration2" = {
          ButtonsOnLeft.value = "M";
          ButtonsOnRight.value = "IAX";
          ShowToolTips.value = false;
        };
      }; # ### kwinrc end here.

      # 键盘 - 布局/高级
      kxkbrc = {
        "Layout"."Use".value = true;
        "Layout"."ResetOldOptions".value = true;
        "Layout"."SwitchMode".value = "Global";
        "Layout"."LayoutList".value = "cn";
        "Layout"."Options".value = "ctrl:swapcaps";
      };
    }; # configFile end here.

    # 键盘 - 快捷键
    shortcuts = {
      "emacs.desktop"."_launch" = "Meta+E";
      "firefox.desktop"."_launch" = "Meta+W";
      "kitty.desktop"."_launch" = "Meta+Return";

      "org.kde.dolphin.desktop"."_launch" = "Meta+F";
      "org.kde.plasma.emojier.desktop"."_launch" = "Meta+.";
      "org.kde.krunner.desktop"."_launch" = [
        "Search"
        "Alt+F2"
        "Meta+X"
      ];

      "ksmserver"."Log Out" = [
        "Meta+Esc"
        "Ctrl+Alt+Del"
      ];

      kwin = {
        "Window Close" = [
          "Alt+F4"
          "Meta+Q"
        ];

        "Window to Desktop 1" = "Alt+1";
        "Window to Desktop 2" = "Alt+2";
        "Window to Desktop 3" = "Alt+3";
        "Window to Desktop 4" = "Alt+4";

        "Switch to Desktop 1" = [
          "Meta+1"
          "Ctrl+F1"
        ];
        "Switch to Desktop 2" = [
          "Meta+2"
          "Ctrl+F2"
        ];
        "Switch to Desktop 3" = [
          "Meta+3"
          "Ctrl+F3"
        ];
        "Switch to Desktop 4" = [
          "Meta+4"
          "Ctrl+F4"
        ];
      }; # kwin end here.
    }; # shortcuts end here.
  }; # programs.plasma end here.
}
