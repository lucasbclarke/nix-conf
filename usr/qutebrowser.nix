{ config, pkgs, lib, ... }:

{
  programs.qutebrowser = {
    enable = true;
    package = pkgs.qutebrowser;

    settings = {
      content = {
        private_browsing = true;
      };
      editor = {
        command = [ "ghostty" "-e" "nvim" "{file}" "-c" "normal {line}G{column0}l" ];
      };
      url = {
        start_pages = "https://google.com";
      };
    };

    keyBindings = {
      normal = {
        "<ctrl-n>" = "completion-item-focus next";
        "<ctrl-p>" = "completion-item-focus prev";
      };
    };

    extraConfig = ''
      import rosepine
      config.load_autoconfig(False)
      rosepine.setup(c, True)

      config.bind('<ctrl-n>', 'completion-item-focus next', mode='command')
      config.bind('<ctrl-p>', 'completion-item-focus prev', mode='command')
      config.bind('<ctrl-n>', 'completion-item-focus next', mode='prompt')
      config.bind('<ctrl-p>', 'completion-item-focus prev', mode='prompt')
    '';

    quickmarks = {
      unix-shell = "https://www.amazon.com.au/Unix-Shell-Programming-3-e/dp/8131701018";
      practice-prog = "https://www.amazon.com.au/Practice-Programming-Brian-W-Kernighan/dp/020161586X";
      elements-computing = "https://www.amazon.com.au/Elements-Computing-Systems-Building-Principles/dp/0262640686";
      unix-power-tools = "https://www.amazon.com.au/Unix-Power-Tools-Jerry-Peek/dp/0596003307";
      programming-gnu = "https://www.amazon.com.au/Programming-GNU-Software-Bk-CD/dp/1565921127";
      unix-nutshell = "https://www.amazon.com.au/Unix-Nutshell-Arnold-Robbins/dp/0596100299";
      unix-prog-env = "https://www.amazon.com.au/Unix-Programming-Environment-KERNIGHAN-PIKE/dp/013937681X";
      refactoring = "https://www.amazon.com.au/Refactoring-Martin-Fowler/dp/0134757599";
      algorithms-c-1-4 = "https://www.amazon.com.au/Algorithms-Parts-1-4-Fundamentals-Structures/dp/0201314525";
      algorithms-c-5 = "https://www.amazon.com.au/Algorithms-Part-Graph-Robert-Sedgewick/dp/0201316633";
      intro-algorithms = "https://www.amazon.com.au/Introduction-Algorithms-fourth-Thomas-Cormen/dp/026204630X";
      art-of-cop-1 = "https://www.amazon.com.au/Art-Computer-Programming-Donald-Knuth/dp/0201896834";
      fundamentals-db = "https://www.amazon.com.au/Fundamentals-Database-Systems-Global-Elmasri/dp/1292097612";
      db-concepts = "https://www.amazon.com.au/Database-Concepts-Sudarshan-Abraham-Silberschatz/dp/9332901384";
      db-complete = "https://www.amazon.com.au/Database-Systems-Complete-Hector-Garcia-Molina/dp/0131873253";
      db-app-oriented = "https://www.amazon.com.au/Database-Systems-Application-Oriented-Approach/dp/0321268458";
      networking-topdown = "https://www.amazon.com.au/Computer-Networking-Down-Approach-Global/dp/1292405465";
      unix-net-prog = "https://www.amazon.com.au/Unix-Network-Programming-V-1/dp/013490012X";
      java-net-prog = "https://www.amazon.com.au/Java-Network-Programming-Elliotte-Harold/dp/0596007213";
      learning-python = "https://www.amazon.com.au/Learning-Python-Mark-Lutz/dp/1449355730";
      computer-networks = "https://www.amazon.com.au/Computer-Networks/dp/9380501935";
      intro-net-cyber = "https://www.amazon.com.au/INTRODUCTION-COMPUTER-NETWORKS-CYBER-SECURITY/dp/B00G50PZNQ";
      networks-tanenbaum = "https://www.amazon.com.au/Computer-Networks-Tanenbaum-International-Economy/dp/9332518742";
      wireless-mobile = "https://www.amazon.com.au/Wireless-Mobile-Networking-Mahbub-Hassan/dp/1032270071";
      write-interpreter-go = "https://www.amazon.com.au/Writing-Interpreter-Go-Thorsten-Ball/dp/3982016118";
      write-compiler-go = "https://www.amazon.com.au/Writing-Compiler-Go-Thorsten-Ball/dp/398201610X";
      suno-beginbot = "https://suno.com/@beginbot";
      swe-textbook = "https://eatham532.github.io/Software-Engineering-HSC-Textbook/Year11/ProgrammingFundamentals/Chapter-01-Software-Development/01-01-Software-Development-Steps/";
      art-of-smart = "https://artofsmart.com.au/";
      yt-chips = "https://www.youtube.com/watch?v=MiUHjLxm3V0";
      physics-booklet = "https://assets.schools.nsw.gov.au/content/dam/doe/sws/schools/s/sydneyh-d/Enrolment%20Documents/Academic%20Docs/Yr-11-Assessment_Booklet.pdf";
      img-to-pdf = "https://www.mcstumble.com/tools/pdf-images-to-pdf";
      swe-github = "https://github.com/TLCC-AU/term-1-programming-fundamentals-project-lucasbclarke";
      maths-is-fun = "https://mathsisfun.com/numbers/math-trainer-multiply.html";
    };

  };
  xdg.configFile."qutebrowser/rosepine".source = ../qutebrowser/rosepine;
}

