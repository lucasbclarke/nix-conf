{ config, pkgs, lib, inputs, ... }:

 {
 programs.nixvim = { 
   keymaps = [
   {
     mode = [
       "n"
       "v"
     ];

     key = "]c";
     action = ":Gitsigns next_hunk<Enter>";
     options = {
       silent = true;
       desc = "next hunk";
     };
   }

   {
     mode = [
       "n"
       "v"
     ];

     key = "[c";
     action = ":Gitsigns prev_hunk<Enter>";
     options = {
       silent = true;
       desc = "prev hunk";
     };
   }

   {
     mode = "v";
     key = "<leader>hs";
     action = "<cmd>lua require('gitsigns').stage_hunk({vim.fn.line('.'), vim.fn.line('v')})<Enter>";
     options = {
       desc = "stage git hunk";
     };
   }

   {
     mode = "v";
     key = "<leader>hr";
     action = "function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end";
     options = {
       desc = "reset git hunk";
     };
   }

   {
     mode = "n";
     key = "<leader>hs";
     action = "<cmd>Gitsigns stage_hunk<Enter>";
     options = {
       silent = true;
       desc = "git stage hunk";
     };
   }

   {
     mode = "n";
     key = "<leader>hr";
     action = "<cmd>Gitsigns reset_hunk<Enter>";
     options = {
       silent = true;
       desc = "git reset hunk";
     };
   }

   {
     mode = "n";
     key = "<leader>hS";
     action = "<cmd>Gitsigns stage_buffer<Enter>";
     options = {
       silent = true;
       desc = "git stage buffer";
     };
   }

   {
     mode = "n";
     key = "<leader>hu";
     action = "<cmd>Gitsigns undo_stage_hunk<Enter>";
     options = {
       silent = true;
       desc = "undo stage hunk";
     };
   }

   {
     mode = "n";
     key = "<leader>hR";
     action = "<cmd> Gitsigns reset_buffer<Enter>";
     options = {
       silent = true;
       desc = "git reset buffer";
     };
   }

   {
     mode = "n";
     key = "<leader>hp";
     action = "<cmd> Gitsigns preview_hunk<Enter>";
     options = {
       silent = true;
       desc = "preview git hunk";
     };
   }

   {
     mode = "n";
     key = "<leader>hd";
     action = "<cmd> Gitsigns diffthis<Enter>";
     options = {
       silent = true;
       desc = "git diff against index";
     };
   }

   {
     mode = "n";
     key = "<leader>hD";
     action = "<cmd> Gitsigns diffthis ~<Enter>";
     options = {
       silent = true;
       desc = "git diff against last commit";
     };
   }

   {
     mode = "n";
     key = "<leader>tb";
     action = "<cmd> Gitsigns toggle_current_line_blame<Enter>";
     options = {
       silent = true;
       desc = "toggle git blame line";
     };
   }

   {
     mode = "n";
     key = "<leader>gd";
     action = "<cmd> Gitsigns toggle_deleted<Enter>";
     options = {
       silent = true;
       desc = "toggle git show deleted";
     };
   }

   {
     mode = [
       "o"
       "x"
     ];
     key = "ih";
     action = ":<C-U>Gitsigns select_hunk<Enter>";
     options = {
       silent = true;
       desc = "select git hunk";
     };
   }

   {
     mode = "n";
     key = "<leader>t";
     action = ":TimeTracker<Enter>";
     options = {
       silent = true;
       desc = "open time tracker";
     };
   }

   {
     mode = "n";
     key = "<leader>s";
     action = "<C-^>";
     options = {
       silent = true;
       desc = "swap files";
     };
   }

   {
     mode = [
        "n"
        "i"
     ];
     key = "<C-c>";
     action = "<Esc>";
     options = {
       silent = true;
       desc = "press control + c for escape";
     };
   }

   {
     mode = [
      "n"
      "v"
     ];
     key = "y";
     action = ''"+y'';
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "Y";
     action = ''"+Y'';
     options = {
       silent = true;
     };
   }

   {
     mode = [
      "n"
      "v"
     ];
     key = "p";
     action = ''"+p'';
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "P";
     action = ''"+P'';
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<C-;>";
     action = "<C-x>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<C-[";
     action = "<C-a>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<leader>n";
     action = ":noh<Enter>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<leader>dl";
     action = ":Ex<Enter>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<leader>ff";
     action = ":Telescope find_files<Enter>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<leader>fg";
     action = ":Telescope live_grep<Enter>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<leader>fb";
     action = ":Telescope buffers<Enter>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<leader>fh";
     action = ":Telescope help_tags<Enter>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<leader>gf";
     action = ":Telescope git_files<Enter>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<leader>gc";
     action = ":Telescope git_commits<Enter>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<leader>cs";
     action = ":Telescope colorscheme<Enter>";
     options = {
       silent = true;
     };
   }

   {
     mode = "n";
     key = "<leader>r";
     action = ":Telescope registers<Enter>";
     options = {
       silent = true;
     };
   }

   ];
 };
}
