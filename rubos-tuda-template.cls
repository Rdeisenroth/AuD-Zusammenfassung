\def\fileversion{1.3.3}
\def\filedate{2021/07/05}

% Sets the LaTeX version for the package to work.
\NeedsTeXFormat{LaTeX2e}
% Identification of the class and its date and version.
\ProvidesClass{rubos-tuda-template} [LaTeX Vorlage für Hausübungen, Zusammenfassungen und Abgaben basierend auf TuDaExercise]

% Made by Ruben Deisenroth, 2021
% Available at https://github.com/Rdeisenroth/TUDA-Hausuebungstemplate/blob/main/rubos-tuda-template.cls

% Packages that need to be loaded before TUDA-Exercise Class
\RequirePackage[table]{xcolor} % Option has to be set before loading TuDaExercise
\RequirePackage{pagecolor} % Used for dark Mode
\PassOptionsToPackage{bookmarksnumbered}{hyperref} % Praktischer
\RequirePackage{scrlfile}
% Wir müssen imakeidx vor Hyperref laden, damit das Stichwortverzeichnis hyperlinks hat
\AfterClass{scrartcl}{
  \RequirePackage{imakeidx}
  \RequirePackage{xr-hyper}
}
\ExplSyntaxOn
\bool_gset_false:N \g_dark_mode_bool
\bool_gset_false:N \g_manual_term_bool
\bool_gset_false:N \g_is_summary_bool
\bool_gset_false:N \g_is_main_file_bool
\bool_gset_false:N \g_is_submission_bool
\bool_gset_false:N \g_ptxcd_ex_load_common_bool
\bool_gset_true:N \g_ptxcd_ex_fancy_rowcolor_bool
\tl_gclear_new:N \datename
\tl_gset:Nn \datename {Datum}
\tl_gclear_new:N \g_rubos_external_label_prefix_tl
\tl_gset:Nn \g_rubos_external_label_prefix_tl {ext:}
\prop_new:N \g_ptxcd_template_opts_prop

\tl_gclear_new:N \g_rubos_keys_tl
\tl_gset:Nn \g_rubos_keys_tl {
  boxarc .code:n = \prop_gput:Nnn \g_ptxcd_template_opts_prop {boxarc} {#1},
  boxarc .initial:n = {0pt},
  boxarc .default:n = {3pt},
  dark_mode .code:n = \pagecolor{black}\color{white}\selectcolormodel{RGB}\bool_gset_true:N \g_dark_mode_bool,
  manual_term .bool_gset:N = \g_manual_term_bool,
  manual_term .initial:n = false,
  manual_term .default:n = true,
  summary .code:n = \bool_if:nTF \g_is_submission_bool {\ClassError{rubos-tuda-template}{summary\space can't\space be\space used\space with\space submission\space mode\space enabled}{disable\space submission\space mode}}{\bool_gset_true:N \g_is_summary_bool\tl_gset:Nn \datename {Stand}},
  submission .code:n = \bool_if:nTF \g_is_summary_bool{\ClassError{rubos-tuda-template}{submission\space can't\space be\space used\space with\space summary\space mode\space enabled}{disable\space summary\space mode}}{\bool_gset_true:N \g_is_submission_bool},
  load_common .bool_gset:N = \g_ptxcd_ex_load_common_bool,
  load_common .initial:n = false,
  load_common . default:n = true,
  default_row_color .bool_gset_inverse:N = \g_ptxcd_ex_fancy_rowcolor_bool,
  default_row_color .initial:n = false,
  default_row_color .default:n = true,
  shell_escape .bool_gset:N = \g_rubos_shell_escape_bool,
  shell_escape .initial:n = true,
  shell_escape .default:n = true,
  main .bool_gset:N = \g_is_main_file_bool,
  main .initial:n = false,
  main .default:n = true,
}
% Additional Class Options
\exp_args:Nno \keys_define:nn {ptxcd/exercise} { \g_rubos_keys_tl }
% Compatibility with older versions (We can't use version check makros before loading the class)
\exp_args:Nno \keys_define:nn {TUDa/pub} { \g_rubos_keys_tl }
\ExplSyntaxOff

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{tudaexercise}}
\ProcessOptions\relax
% \ProcessKeyvalOptions{boxarc}\relax
\LoadClass[
  %fontsize= 12pt,
  a4paper,
  marginpar=false,
  colorback=false,
  points=true,
  leqno,
  fleqn,
  footsepline=.5pt,
]{tudaexercise}

% Packages
\RequirePackage{amsmath}
\RequirePackage{amsthm}
\RequirePackage{booktabs}
\RequirePackage[font=small, labelfont=sc, position=bottom]{caption}
\RequirePackage[labelfont=normalfont, position=bottom]{subcaption}
\RequirePackage{enumitem}
\RequirePackage{mathtools}
\RequirePackage{silence}
% \RequirePackage[T1]{fontenc}
\WarningFilter[sillyfonterror]{latex}{Font shape declaration has}
\ActivateWarningFilters[sillyfonterror]
\ifLuaTeX
  % Fix Font warnings for mathdesign
  \DeclareFontFamily{TU}{mdbch}{}
  \DeclareFontShape{TU}{mdbch}{m}{n}{
    <-> \UnicodeFontFile{lmroman10-regular}{\UnicodeFontTeXLigatures}
  }{}
\fi
\RequirePackage[charter, cal=cmcal]{mathdesign}
\RequirePackage{XCharter}
\DeactivateWarningFilters[sillyfonterror]
% \RequirePackage{mathrsfs} % We use Charter instead
\RequirePackage{tcolorbox}
\tcbuselibrary{skins}
\ExplSyntaxOn
\csname sys_if_shell_unrestricted:T\endcsname{\bool_if:NT \g_rubos_shell_escape_bool {\tcbuselibrary{minted}}}
\ExplSyntaxOff
\RequirePackage{listings}
\RequirePackage{totcount}
\regtotcounter{task}
\RequirePackage{wrapfig}
\RequirePackage{refcount}

% Strings/Names
\defcaptionname*{ngerman, german}{\solutionname}{Lösung}


% --Helper Commands--


\ExplSyntaxOn

% \newcommand{\loadcommon}{
\bool_if:NT \g_ptxcd_ex_load_common_bool {
  % \pagecolor{black}\color{white}
  \RequirePackage[export]{adjustbox}
  % \RequirePackage{amssymb} % We use charter instead
  \RequirePackage[ngerman]{babel}
  \RequirePackage{blindtext}
  \RequirePackage{bm}
  \RequirePackage{colortbl}
  % \RequirePackage{cryptocode}
  % \RequirePackage[utf8]{inputenc} % Has to be loaded before csquotes
  \RequirePackage{csquotes}
  \RequirePackage{ebproof}
  \RequirePackage{etoolbox}
  % \RequirePackage[T1]{fontenc}
  \RequirePackage{forest}
  \RequirePackage{framed}
  \RequirePackage{import}
  % \RequirePackage[utf8]{inputenc} % Already loaded before cs quotes
  \RequirePackage{karnaughmap}
  \RequirePackage{latexsym}
  \RequirePackage{lastpage}
  \RequirePackage{longtable}
  \RequirePackage{makecell}
  \RequirePackage[framemethod=tikz]{mdframed}
  \RequirePackage{mleftright}
  \RequirePackage[longtable]{multirow}
  \RequirePackage{nccmath}
  \RequirePackage{placeins}
  \RequirePackage{pgfplots}
  \RequirePackage{proof}
  \RequirePackage{qtree}
  \RequirePackage{ragged2e}
  \RequirePackage{stackengine}
  \RequirePackage{standalone}
  \RequirePackage{tabularx}
  \RequirePackage{tikz}
  \ExplSyntaxOff % Tikz doesn't Like Expl3 :/
  \usetikzlibrary{3d, angles, animations, arrows, arrows.meta, arrows.spaced, automata, babel, backgrounds, bending, calc, calendar, chains, circuits.ee.IEC, circuits.logic.CDH, circuits.logic.IEC, circuits.logic.US, datavisualization, datavisualization.formats.functions, datavisualization.polar, decorations, decorations.footprints, decorations.fractals, decorations.markings, decorations.pathmorphing, decorations.pathreplacing, decorations.shapes, decorations.text, er, external, fadings, fit, fixedpointarithmetic, folding, fpu, graphs, graphs.standard, intersections, lindenmayersystems, math, matrix, patterns, patterns.meta, perspective, petri, plotmarks, positioning, quotes, rdf, scopes, shadings, shadows, shadows.blur, shapes, shapes.arrows, shapes.callouts, shapes.gates.logic.IEC, shapes.gates.logic.US, shapes.geometric, shapes.misc, shapes.multipart, shapes.symbols, spy, svg.path, through, tikzmark, topaths, trees, turtle, views}
  \RequirePackage{tikz-qtree}
  \ExplSyntaxOn
  \RequirePackage[color=accentcolor,textcolor=white,textwidth=.8cm,textsize=small,loadshadowlibrary]{todonotes}
  % \RequirePackage{tikz-uml}
  \RequirePackage{xifthen}
}
% }
% \loadcommon{}

% Discover tudaci-Version
\exp_args:NNnx \seq_set_split:Nnn \g_tuda_version_seq { ~ } { \use:c {ver@tudaexercise.cls} }
\tl_set:Nx \g_tudaci_version_tl { \seq_item:Nn \g_tuda_version_seq { 2 } }
\tl_set:Nx \g_tudaci_version_tl {\tl_tail:N \g_tudaci_version_tl}
\regex_replace_once:nnN { [a-z] } { } \g_tudaci_version_tl

\newcommand{\getTudaciVersion}[1]{
  \tl_use:N \g_tudaci_version_tl
}
\cs_generate_variant:Nn \fp_set:Nn { Nx }
\newcommand{\IfTudaciVersionAtLeastTF}[3]{
  \fp_compare:nTF {\getTudaciVersion{} >= #1}{#2}{#3}
}
\newcommand{\IfTudaciVersionBetweenTF}[4]{
  \fp_compare:nTF {#1<=\getTudaciVersion{}<=#2}{#3}{#4}
}

% Zero Padding (Pads Number with the wanted amount of zeros)
\int_new:N \l_limit_var_int
\int_new:N \l_amount_var_int
\NewDocumentCommand{\padzeroes}{O{2}m}{
  \int_set:Nn \l_limit_var_int {1}
  \int_set:Nn \l_amount_var_int {#1}
  \bool_set_true:N \l_tmpa_bool
  \bool_while_do:Nn \l_tmpa_bool
  {
    \int_compare:nTF {\l_amount_var_int > 0} {
      \int_compare:nT {#2 < \l_limit_var_int} {
        0
      }
      \int_set:Nn \l_limit_var_int {\int_eval:n {\l_limit_var_int * 10}}
      \int_set:Nn \l_amount_var_int {\int_eval:n {\l_amount_var_int -1}}
    }
    {\bool_set_false:N \l_tmpa_bool}
  }
  #2
}

% Term Creation (Information Area below the Title, depreceated)
\newcommand*{\maketerm}{%
  \term{%
    \begin{minipage}[t]{.5\textwidth}%
      \printFachbereich{}\\
      \printDozent{}%
    \end{minipage}%
    \begin{minipage}[t]{.49\textwidth}%
      \raggedleft%
      \begin{flushright}%
        \printSemester{}\\
        \printVersion{}
      \end{flushright}
    \end{minipage}
    \vspace{3ex}\\
    \printTopic{}\\
    \printSlides{}\\
    \printTotalPoints{}\\
    \printDueDate{}
  }
}

\IfTudaciVersionAtLeastTF{3.13}{
\tl_gclear_new:N \g__ptxcd_task_properties_collector_tl
\tl_gclear_new:N \g__ptxcd_task_properties_loaded_tl

\RenewDocumentEnvironment{task}{om}{
  \IfNoValueF{#1}{\keys_set:nn {ptxcd/task}{#1}}
  \@task{#2}
  \bool_if:NF \l__ptxcd_points_auto_bool {
    \cs_if_exist_use:NF \prop_gput:Nxx
    {\exp_args:NNx \prop_gput:Nnx}
    \g__ptxcd_points_collector_prop
    {\thetask} {\fp_to_decimal:N \l_ptxcd_ex_task_points_fp}
  }
}{
  % Store Task Properties (since we don't want to overwrite the subtask property, we have to set each one manually)
  \tl_clear_new:N \l__ptxcd_task_properties_collector_tl
  \tl_set_eq:NN \l__ptxcd_task_properties_collector_tl \g__ptxcd_task_properties_collector_tl
  \rubos_prop_nested_set:Nxx \l__ptxcd_task_properties_collector_tl {\the\value{task}, title} {\tl_to_str:n {#2}}
  \rubos_prop_nested_set:Nxx \l__ptxcd_task_properties_collector_tl {\the\value{task}, thetask} {\exp_args:Ne\tl_to_str:n{\thetask}}
  \rubos_prop_nested_set:Nxx \l__ptxcd_task_properties_collector_tl {\the\value{task}, taskformat} {\exp_args:Ne\tl_to_str:n{\taskformat}} % We expand here, to account for thinks like a per task \thetask{} command
  \rubos_prop_nested_set:Nxx \l__ptxcd_task_properties_collector_tl {\the\value{task}, credit} {\tl_to_str:N \l_ptxcd_ex_task_credit_tl}
  \rubos_prop_nested_set:Nxx \l__ptxcd_task_properties_collector_tl {\the\value{task}, pointsauto} {\bool_if:NTF \l__ptxcd_points_auto_bool {true} {false}}
  \rubos_prop_nested_set:Nxx \l__ptxcd_task_properties_collector_tl {\the\value{task}, points} {\bool_if:NTF \l__ptxcd_points_auto_bool {\fp_use:N \g__ptxcd_ex_collected_points_fp} {\fp_use:N \l_ptxcd_ex_task_points_fp}}
  \rubos_prop_nested_set:Nxx \l__ptxcd_task_properties_collector_tl {\the\value{task}, solution} {\bool_if:NTF \l_ptxcd_ex_solution_bool {true}{false}}
  \tl_gset_eq:NN \g__ptxcd_task_properties_collector_tl \l__ptxcd_task_properties_collector_tl

  % a
  \bool_if:NT \l__ptxcd_points_auto_bool {
    \cs_if_exist_use:NF \prop_gput:Nxx
    {\exp_args:NNx \prop_gput:Nnx}
    \g__ptxcd_points_collector_prop
    {\thetask} {\fp_to_decimal:N \g__ptxcd_ex_collected_points_fp}
    \fp_gzero:N \g__ptxcd_ex_collected_points_fp
  }
}

\RenewDocumentEnvironment{subtask}{o}{
  \tl_if_in:nnT {#1} {=} {
    \keys_set:nn {ptxcd/subtask} {#1}
  }
  \bool_if:NTF \l_ptxcd_ex_subtask_fallback_bool {
    \@subtask{\IfNoValueF{#1}{#1}}
  }{
    \@subtask{\l_ptxcd_ex_title_tl}
  }

  \tl_clear_new:N \l__ptxcd_task_properties_collector_tl
  \tl_set_eq:NN \l__ptxcd_task_properties_collector_tl \g__ptxcd_task_properties_collector_tl
  \rubos_prop_nested_set:Nxx \l__ptxcd_task_properties_collector_tl {\the\value{task}, subtasks, \the\value{subtask}} {
    title={\tl_to_str:N \l_ptxcd_ex_title_tl},
    credit={\tl_to_str:N \l_ptxcd_ex_subtask_credit_tl},
    points={\fp_use:N \l_ptxcd_ex_subtask_points_fp},
    thesubtask={\exp_args:Ne\tl_to_str:n{\thesubtask}},
    subtaskformat={\exp_args:Ne\tl_to_str:n{\subtaskformat}},
  }
  \tl_gset_eq:NN \g__ptxcd_task_properties_collector_tl \l__ptxcd_task_properties_collector_tl
}{}
\newcommand*{\ptxcd@LoadTaskProperties}[1]{
  \tl_gset:Nn \g__ptxcd_task_properties_loaded_tl {#1}
}

\bool_if:NT \g__ptxcd_points_bool {
  \BeforeClosingMainAux{
    \iow_now:Nx \@auxout{
      \exp_not:N \ptxcd@LoadTaskProperties{\g__ptxcd_task_properties_collector_tl}
    }
  }
}

% Modify GetPoints Command to work with makros
\DeclareDocumentCommand{\getPoints}{m}{
  % \exp_args:NNx \prop_get:NnNTF \g__ptxcd_loaded_points_prop {#1} \l_tmpa_tl
  \rubos_prop_nested_get:NxNTF \g__ptxcd_task_properties_loaded_tl {#1,points} \l_tmpa_tl
  {\l_tmpa_tl}
  {\nfss@text{\reset@font\bfseries??}}
}

\DeclareDocumentCommand{\getSubPoints}{mm}{
  \rubos_prop_nested_get:NxNTF \g__ptxcd_task_properties_loaded_tl {#1,subtasks,#2,points} \l_tmpa_tl
  {\l_tmpa_tl}
  {\nfss@text{\reset@font\bfseries??}}
}

\newcommand{\getTaskTitle}[1]{
  \exp_args:Nnx \__rubos_nested_contains:nnTF {\g__ptxcd_task_properties_loaded_tl} {#1,title}
  {
    \exp_args:NNx \rubos_prop_nested_get:nn {\g__ptxcd_task_properties_loaded_tl} {#1,title}
  }
  {\nfss@text{\reset@font\bfseries??}}
}
\newcommand{\getSubTaskTitle}[2]{
  \exp_args:Nnx \__rubos_nested_contains:nnTF {\g__ptxcd_task_properties_loaded_tl} {#1,subtasks,#2,title}
  {
    \exp_args:NNx \rubos_prop_nested_get:nn {\g__ptxcd_task_properties_loaded_tl} {#1,subtasks,#2,title}
  }
  {\nfss@text{\reset@font\bfseries??}}
}

% Get Property of a Task, or prints ?? if not present
% [#1]: Optional task number (can be obtained by \the\value{task})
% #2: Property Name (key)
\NewDocumentCommand{\getTaskProperty}{O{\the\value{task}}m}{
  \rubos_prop_nested_get:NxNTF \g__ptxcd_task_properties_loaded_tl {#1,#2} \l_ptxcd_temp_task_prop_tl
  {
    \l_ptxcd_temp_task_prop_tl
  }
  {\nfss@text{\reset@font\bfseries??}}
}

% Get Property of a Subtask, or prints ?? if not present
% [#1]: Optional task number (can be obtained by \the\value{task})
% [#2]: Optional subtask number (can be obtained by \the\value{subtask})
% #3: Property Name (key)
\NewDocumentCommand{\getSubTaskProperty}{O{\the\value{task}}O{\the\value{subtask}}m}{
\rubos_prop_nested_get:NxNTF \g__ptxcd_task_properties_loaded_tl {#1,subtasks,#2,#3} \l_ptxcd_temp_subtask_prop_tl
{
  \l_ptxcd_temp_subtask_prop_tl
}
{\nfss@text{\reset@font\bfseries??}}
}

% Logik zum rausfinden ob es einen subtask gibt
\newcommand{\IfSubtasksTF}[3][\the\value{task}]{
  \exp_args:Nnx \__rubos_nested_contains:nnTF {\g__ptxcd_task_properties_loaded_tl} {#1,subtasks} {#2} {#3}
}


% \NewDocumentCommand{\mapTasks}{sO{1}m}{
%   % \cs_gset_nopar:Nn \__ptxcd_map_points_helper:nn {#3}
%   \prop_if_empty:NTF \g__ptxcd_loaded_points_prop {
%     \msg_warning:nn {tudaexercise} {empty-point-mapping}
%     %  \__ptxcd_map_points_helper:nn {?task?} {?points?}
%   }{
%     \int_gset:Nn \g_ptxcd_tmp_int {\value{task}}
%     \setcounter{task}{#2}
%     \bool_gset_true:N \g_tmpa_bool
%     \bool_while_do:Nn \g_tmpa_bool
%     {
%       \exp_args:NNx \prop_get:NnNTF \g__ptxcd_loaded_points_prop {\thetask} \l_tmpa_tl
%       {
%         \bool_if:nT {#1 || !\fp_compare_p:n {\l_tmpa_tl = 0}}
%         {
%           % \group_begin:
%           #3
%           % \group_end:
%         }
%       }
%       {\bool_gset_false:N \g_tmpa_bool}
%       \stepcounter{task}
%     }
%     \setcounter{task}{\int_use:N \g_ptxcd_tmp_int}
%   }
% }
% Star currently useless
\NewDocumentCommand{\mapTasks}{sO{1}O{-1}m}{
\prop_clear_new:N \l_temp_task_mapping_prop
\exp_args:NNf \prop_set_from_keyval:Nn \l_temp_task_mapping_prop {
  \g__ptxcd_task_properties_loaded_tl
}
\int_zero_new:N \l_ptxcd_orig_task_int
\int_set:Nn \l_ptxcd_orig_task_int {\value{task}}
\setcounter{task}{#2}
\prop_map_inline:Nn \l_temp_task_mapping_prop {
  \bool_if:nT {\int_compare_p:n {##1 >= #2} && (\int_compare_p:n {#3 = -1} || \int_compare_p:n {##1 <= #3})}{
    \setcounter{task}{##1}
    #4
  }
}
\setcounter{task}{\int_use:N \l_ptxcd_orig_task_int}
}

% Subtasks mapping
\NewDocumentCommand{\mapSubtasks}{sO{1}m}{
  \rubos_prop_nested_get:NxNTF \g__ptxcd_task_properties_loaded_tl {\the\value{task},subtasks} \l_temp_subtask_points_tl
  {
    \prop_clear_new:N \l_temp_subtask_mapping_prop
    \exp_args:NNf \prop_set_from_keyval:Nn \l_temp_subtask_mapping_prop {
      \l_temp_subtask_points_tl
    }
    \int_zero_new:N \l_ptxcd_orig_subtask_int
    \int_set:Nn \l_ptxcd_orig_subtask_int {\value{subtask}}
    \setcounter{subtask}{#2}
    \prop_map_inline:Nn \l_temp_subtask_mapping_prop {
      \int_compare:nT {##1 >= #2}{
        \setcounter{subtask}{##1}
        #3
      }
    }
    \setcounter{subtask}{\int_use:N \l_ptxcd_orig_subtask_int}
  }
  {}
}
}{}

% Just a basic recursion test
\newcommand{\rubosfib}[1]{
  \int_compare:nTF{#1 < 2}
  {
    #1
  }{
    \int_eval:n {\rubosfib{\int_eval:n {#1 - 1}} + \rubosfib{\int_eval:n {#1 - 2}}}
  }
}

% #1: Token List which is a nested Property List (like: {3={a)=3,b)=2,},4={a)=5,b)=3,c)=8}})
% #2: Comma List (List of the keys to get the desired value)
% returns: Tokenlist
\cs_new:Npn \rubos_prop_nested_get:nn #1#2 {
  \tl_clear_new:N \l_rubos_nestedcurr_tl
  \tl_set:Nn \l_rubos_nestedcurr_tl {#1}
  \prop_clear_new:N \l_rubos_nestedcurr_prop
  \clist_map_inline:nn {#2}{
    % Check if Current Tokenlist is a Property List
    \__rubos_is_prop_list:nTF {\tl_use:N \l_rubos_nestedcurr_tl} {
      % Current List is a Property List
      % Parse Property List
      \exp_args:NNf \prop_set_from_keyval:Nn \l_rubos_nestedcurr_prop {
        \l_rubos_nestedcurr_tl
      }
      % Make sure key is present
      \prop_if_in:NnTF \l_rubos_nestedcurr_prop {##1} {
        % Key is present
        \prop_get:NnN \l_rubos_nestedcurr_prop {##1} \l_rubos_nestedcurr_tl
      } {
        % Key is not present
        \ClassError{rubos_tuda_template}{Subproperty~##1~does~not~exist~the~nested~property~list!}{Subproperty~##1~does~not~exist~the~nested~property~list!}
      }
    }{
      % Current List is no Property List
      \ClassError{rubos_tuda_template}{Subproperty~##1~could~not~be~found~because~toplist~is~no~property~list!}{toplist~is~no~property~list}
    }
  }
  % Put result in Output stream
  \tl_use:N \l_rubos_nestedcurr_tl
}

\cs_set_eq:NN\nestedget \rubos_prop_nested_get:nn

\prg_new_protected_conditional:Npnn \rubos_prop_nested_get:NnN #1#2#3 { T , F , TF }{
  \tl_clear_new:N \l_rubos_nestedcurr_tl
  \tl_set_eq:NN \l_rubos_nestedcurr_tl #1
  \bool_set_true:N \l_rubos_nestedcontains_bool
  \prop_clear_new:N \l_rubos_nestedcurr_prop
  \clist_map_inline:nn {#2}{
    \bool_if:NT \l_rubos_nestedcontains_bool {

      % Check if Current Tokenlist is a Property List
      \exp_args:Nf \__rubos_is_prop_list:nTF {\l_rubos_nestedcurr_tl} {
        % Current List is a Property List
        % Parse Property List
        \exp_args:NNf \prop_set_from_keyval:Nn \l_rubos_nestedcurr_prop {
          \l_rubos_nestedcurr_tl
        }
        % Make sure key is present
        \prop_if_in:NnTF \l_rubos_nestedcurr_prop {##1} {
          % Key is present
          \prop_get:NnN \l_rubos_nestedcurr_prop {##1} \l_rubos_nestedcurr_tl
        } {
          % Key is not present
          \bool_set_false:N \l_rubos_nestedcontains_bool
        }
      }{
        % Current List is no Property List
        \bool_set_false:N \l_rubos_nestedcontains_bool
      }
    }
  }
  \bool_if:NTF \l_rubos_nestedcontains_bool {
    % Copy Result to output list
    \tl_set_eq:NN #3 \l_rubos_nestedcurr_tl
    \prg_return_true:
  }{
    \prg_return_false:
  }
}

\prg_generate_conditional_variant:Nnn \rubos_prop_nested_get:NnN { NV , Nv , No, Nx , c , cV , cv , co, cx } { T , F , TF }

% #1: Token List which is a nested Property List (will throw class error if token List is faulty!!)
% #2: Comma List (List of the keys to get the desired value)
% #3: The Value to set (token List)
% returns: Tokenlist
\cs_new:Npn \rubos_prop_nested_set:Nnn #1#2#3 {
  \tl_clear_new:N \l_rubos_nestedcurr_tl
  \tl_set_eq:NN \l_rubos_nestedcurr_tl {#1}
  \clist_clear_new:N \l_rubos_nestedkeys_remaining_clist
  \clist_set:Nn \l_rubos_nestedkeys_remaining_clist {#2}
  \clist_clear_new:N \l_rubos_nestedkeys_done_clist
  \str_clear_new:N \l_rubos_nestedkeys_current_key_tl
  \seq_clear_new:N \l_rubos_nestedstack_seq
  \prop_clear_new:N \l_rubos_nestedcurr_prop
  \bool_set_true:N \l_rubos_nestediterate_bool
  % Fill Stack and find out insertion point
  \bool_while_do:Nn \l_rubos_nestediterate_bool {
    % Keys remain
    \clist_pop:NNTF \l_rubos_nestedkeys_remaining_clist \l_rubos_nestedkeys_current_key_tl {
      \exp_args:NNe \clist_push:Nn \l_rubos_nestedkeys_done_clist {\l_rubos_nestedkeys_current_key_tl}
      % Check if Current Tokenlist is a Property List
      \__rubos_is_prop_list:nTF {\l_rubos_nestedcurr_tl} {
        % Current List is a Property List
        % Parse Property List
        \exp_args:NNf \prop_set_from_keyval:Nn \l_rubos_nestedcurr_prop {
          \l_rubos_nestedcurr_tl
        }
        \exp_args:NNf \seq_put_left:Nn \l_rubos_nestedstack_seq {\l_rubos_nestedcurr_tl}
        % Test if key is present
        \exp_args:NNf \prop_get:NnNF \l_rubos_nestedcurr_prop {\l_rubos_nestedkeys_current_key_tl} \l_rubos_nestedcurr_tl {
          % Key is not Present
          \bool_set_false:N \l_rubos_nestediterate_bool
        }
      }{
        % Current List is no Property List
        \bool_set_false:N \l_rubos_nestediterate_bool
        \ClassError{rubos_tuda_template}{List~that~should~contain~Property~\tl_use:N \l_rubos_nestedkeys_current_key_tl\space is~no~property~list!}{Token~List~is~no~property~list}
      }
    } {
      % no keys remain
      \bool_set_false:N \l_rubos_nestediterate_bool
    }
  }

  % Create nested Property List to insert based on insertion point
  \tl_clear_new:N \l_rubos_new_nestedprop_tl
  \tl_set:Nn \l_rubos_new_nestedprop_tl {#3}
  \clist_reverse:N \l_rubos_nestedkeys_remaining_clist
  \clist_map_inline:Nn \l_rubos_nestedkeys_remaining_clist {
    \prop_clear:N \l_rubos_nestedcurr_prop
    \prop_put:Noo \l_rubos_nestedcurr_prop {##1} {\l_rubos_new_nestedprop_tl}
    \tl_clear:N \l_rubos_new_nestedprop_tl
    \prop_map_inline:Nn \l_rubos_nestedcurr_prop {
      \tl_put_right:Nn \l_rubos_new_nestedprop_tl {####1={####2},}
    }
  }

  % Insert at insertion point using the stack
  \clist_map_inline:Nn \l_rubos_nestedkeys_done_clist {
    % ##1,
    % Parse Next Prop List from Stack
    \prop_clear:N \l_rubos_nestedcurr_prop
    \seq_pop_left:NN \l_rubos_nestedstack_seq \l_rubos_nestedcurr_tl
    \exp_args:NNo \prop_set_from_keyval:Nn \l_rubos_nestedcurr_prop {
      \l_rubos_nestedcurr_tl
    }
    % \tl_set:Nx \l_rubos_nestedstack_tl {\tl_tail:N \l_rubos_nestedstack_tl}
    \prop_put:Noo \l_rubos_nestedcurr_prop {##1} {\l_rubos_new_nestedprop_tl}

    \tl_clear:N \l_rubos_new_nestedprop_tl
    \prop_map_inline:Nn \l_rubos_nestedcurr_prop {
      \tl_put_right:Nn \l_rubos_new_nestedprop_tl {####1={####2},}
    }
  }

  % % Copy result to Output List
  \tl_set_eq:NN #1 \l_rubos_new_nestedprop_tl
}

\cs_generate_variant:Nn \rubos_prop_nested_set:Nnn { Nxx,Nxn,Noo,Nxo }

\cs_set_eq:NN\nestedset \rubos_prop_nested_set:nn

\prg_new_conditional:Npnn \__rubos_is_prop_list:n #1 { p, T, F, TF } {
  \bool_if:nT {\tl_if_empty_p:n {#1} || \tl_if_blank_p:n {#1}} {\prg_return_true:}
  \bool_set_true:N \l_rubos_is_prop_bool
  \exp_args:Nf \clist_map_inline:nn {#1} {
    \bool_if:NT \l_rubos_is_prop_bool {
      % ##1
      \bool_if:nF {\tl_if_empty_p:n {#1} || \tl_if_blank_p:n {#1}} {
        % Must contain =
        \tl_if_in:nnF {##1} {=} {\bool_set_false:N \l_rubos_is_prop_bool}
        % Must have at least length 3
        \int_compare:nF {\tl_count:n {##1} > 2} {\bool_set_false:N \l_rubos_is_prop_bool}
        \regex_match:nnF {.+=.+} {##1} {\bool_set_false:N \l_rubos_is_prop_bool}
        % Might refine Logic later
        % \int_zero_new:N \l_tmp_regex_match_count_int
        % \regex_count:nnN {=} {##1} \l_tmp_regex_match_count_int
        % \int_compare:nF {\l_tmp_regex_match_count_int = 1} {\int_use:N \l_tmp_regex_match_count_int \bool_set_false:N \l_rubos_is_prop_bool}
      }
    }
  }
  \bool_if:NTF \l_rubos_is_prop_bool {
    \prg_return_true:
  } {
    \prg_return_false:
  }
}

% #1: Token List which is a nested Property List (like: {3={a)=3,b)=2,},4={a)=5,b)=3,c)=8}})
% #2: Comma List (List of the keys to get the desired value)
\prg_new_conditional:Npnn \__rubos_nested_contains:nn #1#2 { p, T, F, TF } {
  \tl_clear_new:N \l_rubos_nestedcurr_tl
  \tl_set:Nf \l_rubos_nestedcurr_tl {#1}
  \prop_clear_new:N \l_rubos_nestedcurr_prop
  % Since you can't use the return statement inside a map function...
  \bool_set_true:N \l_rubos_nestedcontains_bool
  \clist_map_inline:nn {#2}{
    \bool_if:NT \l_rubos_nestedcontains_bool {
      % Check if Current Tokenlist is a Property List
      \tl_if_in:NnTF \l_rubos_nestedcurr_tl {=} {
        % Current List is a Property List
        % Parse Property List
        \exp_args:NNf \prop_set_from_keyval:Nn \l_rubos_nestedcurr_prop {
          \l_rubos_nestedcurr_tl
        }
        % Make sure key is present
        \prop_if_in:NnTF \l_rubos_nestedcurr_prop {##1} {
          % Key is present
          \prop_get:NnN \l_rubos_nestedcurr_prop {##1} \l_rubos_nestedcurr_tl
        } {
          % Key is not present
          \bool_set_false:N \l_rubos_nestedcontains_bool
        }
      }{
        % Current List is no Property List
        \bool_set_false:N \l_rubos_nestedcontains_bool
      }
    }
  }
  % Wanted Key is contained
  \bool_if:NTF \l_rubos_nestedcontains_bool {
    \prg_return_true:
  } {
    \prg_return_false:
  }
}

\prg_generate_conditional_variant:Nnn \rubos_prop_nested_get:nn { nx , ne } { p, T , F , TF }

\cs_set_eq:NN\IfNestedContainsT \__rubos_nested_contains:nnT
\cs_set_eq:NN\IfNestedContainsF \__rubos_nested_contains:nnF
\cs_set_eq:NN\IfNestedContainsTF \__rubos_nested_contains:nnTF

\cs_new:Npn \rubos_print_nested_tl:n #1 {
  % \tl_set:Nf \l_tmpa_tl {#1}
  \{
  \exp_args:Nf \tl_to_str:n {#1}
  \}
}

\cs_set_eq:NN \printNested \rubos_print_nested_tl:n

\ExplSyntaxOff

% --Document Settings-- %

\ExplSyntaxOn

% Sheet number
\newcommand*{\getSheetnumber}{
  \IfTudaciVersionAtLeastTF{3.0}{
    \g_ptxcd_ex_sheetnum_tl
  }{
    \g_TUDa_ex_sheetnum_tl
  }}
\newcommand*{\printSheetNumber}{\tl_if_empty:NF \g_ptxcd_ex_sheetnum_tl {\sffamily\textbf{Übungsblatt\space{}Nummer:}\space\padzeroes{\getSheetnumber}}}

% Sheet Version
\tl_new:N \g_ptxcd_ex_sheetver_tl
\tl_gclear_new:N \printVersion
\newcommand*{\version}[1]{
  \tl_gset:Nn \g_ptxcd_ex_sheetver_tl {#1}
  \tl_if_empty:NF \g_ptxcd_ex_sheetver_tl {\tl_gset:Nn \printVersion {\sffamily\textbf{v\getVersion}}}
}
\newcommand*{\getVersion}{\g_ptxcd_ex_sheetver_tl}

% Group Number
\tl_new:N \g_ptxcd_ex_groupnum_tl
\tl_gclear_new:N \printGroupNumber
\newcommand*{\groupnumber}[1]{
  \tl_gset:Nn \g_ptxcd_ex_groupnum_tl {#1}
  \tl_if_empty:NF \g_ptxcd_ex_groupnum_tl {\tl_gset:Nn \printGroupNumber {\sffamily\textbf{Übungsgruppe\space{}Nummer:}\space\padzeroes{\getGroupnumber}}}
}
\newcommand*{\getGroupnumber}{\g_ptxcd_ex_groupnum_tl}

% Group Leader
\tl_new:N \g_ptxcd_ex_groupleader_tl
\tl_gclear_new:N \printGroupLeader
\newcommand*{\groupleader}[1]{
  \tl_gset:Nn \g_ptxcd_ex_groupleader_tl {#1}
  \tl_if_empty:NF \g_ptxcd_ex_groupleader_tl {\tl_gset:Nn \printGroupLeader {\sffamily\textbf{Übungsgruppenleiter:}\space\getGroupLeader}}
}
\newcommand*{\getGroupLeader}{\g_ptxcd_ex_groupleader_tl}

% Dozent
\tl_new:N \g_ptxcd_ex_dozent_tl
\tl_gclear_new:N \printDozent
\newcommand*{\dozent}[1]{
  \tl_gset:Nn \g_ptxcd_ex_dozent_tl {#1}
  \tl_if_empty:NF \g_ptxcd_ex_dozent_tl {\tl_gset:Nn \printDozent {\sffamily\textbf{\getDozent}}}
}
\newcommand*{\getDozent}{\g_ptxcd_ex_dozent_tl}

% Topic
\tl_new:N \g_ptxcd_ex_topic_tl
\tl_gclear_new:N \printTopic
\newcommand*{\topic}[1]{
  \tl_gset:Nn \g_ptxcd_ex_topic_tl {#1}
  \tl_if_empty:NF \g_ptxcd_ex_topic_tl {\tl_gset:Nn \printTopic {\sffamily\textbf{Themen:}\hfill\getTopic{}}}
}
\newcommand*{\getTopic}{\g_ptxcd_ex_topic_tl}

% slides
\tl_new:N \g_ptxcd_ex_slides_tl
\tl_gclear_new:N \printSlides
\newcommand*{\slides}[1]{
  \tl_gset:Nn \g_ptxcd_ex_slides_tl {#1}
  \tl_if_empty:NF \g_ptxcd_ex_slides_tl {\tl_gset:Nn \printSlides {\sffamily\textbf{Relevante\space{}Foliensätze:}\hfill\getSlides{}}}
}
\newcommand*{\getSlides}{\g_ptxcd_ex_slides_tl}

% Due Date
\tl_new:N \g_ptxcd_ex_due_date_tl
\tl_gclear_new:N \printDueDate
\newcommand*{\dueDate}[1]{
  \tl_gset:Nn \g_ptxcd_ex_due_date_tl {#1}
  \tl_if_empty:NF \g_ptxcd_ex_due_date_tl {\tl_gset:Nn \printDueDate {\sffamily\textbf{Abgabe\space{}der\space{}Hausübung:}\hfill\getDueDate{}}}
}
\dueDate{}
\newcommand*{\getDueDate}{\g_ptxcd_ex_due_date_tl}

% Total Points
\newcommand*{\printTotalPoints}{\textbf{\textsf{Maximal\space{}erreichbare\space{}Punkte:}}\hfill\getPointsTotal{}\space{}\fp_compare:nTF {\getPointsTotal{}=1}\PointName\PointsName}

% Semester
\tl_new:N \g_ptxcd_ex_semester_tl
\tl_gclear_new:N \printSemester
\newcommand*{\semester}[1]{
  \tl_gset:Nn \g_ptxcd_ex_semester_tl {#1}
  \tl_if_empty:NF \g_ptxcd_ex_semester_tl {\tl_gset:Nn \printSemester {\textsf{\textbf{Semester:~}}\getSemester}}
}
\newcommand*{\getSemester}{\g_ptxcd_ex_semester_tl}

% Fachbereich
\tl_new:N \g_ptxcd_ex_fachbereich_tl
\tl_gclear_new:N \printFachbereich
\newcommand*{\fachbereich}[1]{
  \tl_gset:Nn \g_ptxcd_ex_fachbereich_tl {#1}
  \tl_if_empty:NF \g_ptxcd_ex_fachbereich_tl {\tl_gset:Nn \printFachbereich {\textsf{\textbf{Fachbereich:~}}\getFachbereich}}
}
\semester{}
\newcommand*{\getFachbereich}{\g_ptxcd_ex_fachbereich_tl}
% \newcommand*{\printFachbereich}{\tl_if_empty:NF \g_ptxcd_ex_fachbereich_tl {\sffamily\textbf{Fachbereich\space\getFachbereich}}}

% Short Title
\newcommand*{\getShortTitle}{\IfTudaciVersionAtLeastTF{3.0}{
    \g_ptxcd_shorttitle_tl
  }{
    \g_TUDa_shorttitle_tl
  }}

% Author
\tl_gclear_new:N \printAuthor
\renewcommand*{\author}[1]{
  \seq_gset_split:Nnn \g_ptxcd_author_seq {\and} {#1}
  \seq_if_empty:NF \g_ptxcd_author_seq {\tl_gset:Nn \printAuthor {\textbf{\textsf{\int_compare:nTF{\seq_count:N \g_ptxcd_author_seq > 1}{Authoren}{Author}:~}}\seq_use:Nnnn \g_ptxcd_author_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}}
}

% Contributors
\seq_new:N \g_ptxcd_contributor_seq
\tl_gclear_new:N \printContributor
\newcommand*\contributor[1]{
  \seq_gset_split:Nnn \g_ptxcd_contributor_seq {\and} {#1}
  \seq_if_empty:NF \g_ptxcd_contributor_seq {\tl_gset:Nn \printContributor {\textbf{\textsf{Helfer:~}}\seq_use:Nnnn \g_ptxcd_contributor_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}}
}

% Submittors
\seq_new:N \g_ptxcd_submittors_seq
% \tl_gclear_new:N \printSubmittors
% \ifcsname c@submittor\endcsname\else
%   \newcounter{submittor}
% \fi
% \setcounter{submittor}{0}
\newcommand*{\addSubmittor}[2]{
  \bool_if:nF \g_is_submission_bool {
    \ClassError{rubos_tuda_template}{Dieser\space Befehl\space Benötigt\space den\space submission\space Modus}{Schalte\space den\space submission\space Modus\space ein}
  }
  \str_if_eq:nnT {#1} {} {
    \ClassError{rubos_tuda_template}{Name\space darf \space nicht\space leer\space sein!}{Gib\space einen\space gültigen\space Namen\space ein}
  }
  \str_if_eq:nnT {#2} {} {
    \ClassError{rubos_tuda_template}{Matrikelnummer\space darf \space nicht\space leer\space sein!}{Gib\space eine\space gültige\space Matrikelnummer\space ein}
  }

  \seq_gput_right:Nn \g_ptxcd_submittors_seq {#1}
  \tl_gclear_new:c {ptxcd_submittors_#1_matrikelnummer_tl}
  \tl_gset:cn {ptxcd_submittors_#1_matrikelnummer_tl} {#2}
  % \seq_if_empty:NF \g_ptxcd_submittors_seq {\tl_gset:Nn \printContributor {\textbf{\textsf{Helfer:~}}\seq_use:Nnnn \g_ptxcd_submittors_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}}
}

\newcommand*{\getMatrikelnummer}[1]{
  \use:c {ptxcd_submittors_#1_matrikelnummer_tl}
}

\newcommand*{\printSubmittor}[1]{
  #1\space{}(Mat.:\space{}\getMatrikelnummer{#1})
}

\newcommand*{\printSubmittors}[1]{
  \textsf{\textbf{Abgabe}}\seq_if_empty:NF \g_ptxcd_submittors_seq {\textsf{\textbf{\space{}von:}}
    \\\gdef\ptxcd_nextsep_submittors{}
    \seq_map_inline:Nn \g_ptxcd_submittors_seq {
      \ptxcd_nextsep_submittors{}
      \printSubmittor{##1}
      \gdef\ptxcd_nextsep_submittors{,\\}
    }}
}

% \newcommand*{\printContributor}{
%   \seq_if_empty:NF \g_ptxcd_contributor_seq {\textbf{\textsf{Helfer:~}}\seq_use:Nnnn \g_ptxcd_contributor_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}
% }

% Date
\tl_gclear_new:N \printDate
\renewcommand*{\date}[1]{
  \tl_gset:Nn \@date {#1}
  \tl_if_empty:NF \@date {\tl_gset:Nn \printDate {\textsf{\textbf{\datename{}:~}}\@date}}
}
% \newcommand*{\printDate}{
%   \tl_if_empty:NF \@date {\textbf{\textsf{Datum:~}}\@date}
% }

\clist_new:N \g_ptxcd_ex_term_order_clist
\clist_gset:Nn \g_ptxcd_ex_term_order_clist {printAuthor,printSemester,printContributor,printVersion,quad,quad,printDate,printFachbereich}
\newcommand*{\termOrder}[1]{\tl_gset:Nn \g_ptxcd_ex_term_order_clist {#1}}

\tl_gclear_new:N \g_ptxcd_ex_term_style_tl
\newcommand*{\termStyle}[1]{\tl_gset:Nn \g_ptxcd_ex_term_style_tl {#1}}
\termStyle{left-right}
\seq_gclear_new:N \g_ptxcd_term_left_seq
\seq_gclear_new:N \g_ptxcd_term_right_seq
\newcommand{\termLeft}[1]{
  \clist_gclear_new:N \g_ptxcd_temp_clist
  \tl_gset:Nn \g_ptxcd_temp_clist {#1}
  \clist_map_inline:Nn \g_ptxcd_temp_clist {
    \tl_if_empty:cF {##1} {
      \seq_put_right:Nn \g_ptxcd_term_left_seq {\use:c {##1}}
    }
  }
}
\newcommand{\termRight}[1]{
  \clist_gclear_new:N \g_ptxcd_temp_clist
  \tl_gset:Nn \g_ptxcd_temp_clist {#1}
  \clist_map_inline:Nn \g_ptxcd_temp_clist {
    \tl_if_empty:cF {##1} {
      \seq_put_right:Nn \g_ptxcd_term_right_seq {\use:c {##1}}
    }
  }
}

\prg_new_conditional:Nnn \__ptxcd_if_dark_mode: {T,F,TF} {
  \bool_if:NTF \g_dark_mode_bool
  {\prg_return_true:}
  {\prg_return_false:}
}

\cs_set_eq:NN\IfDarkModeT \__ptxcd_if_dark_mode:T
\cs_set_eq:NN\IfDarkModeF \__ptxcd_if_dark_mode:F
\cs_set_eq:NN\IfDarkModeTF \__ptxcd_if_dark_mode:TF

\prg_new_conditional:Nnn \__rubos_if_shell_escape: {T,F,TF} {
  \bool_if:NTF \g_rubos_shell_escape_bool
  {\sys_if_shell_unrestricted:TF
    {\prg_return_true:}
    {\prg_return_false:}
  }
  {\prg_return_false:}
}

\cs_set_eq:NN\IfShellEscapeT \__rubos_if_shell_escape:T
\cs_set_eq:NN\IfShellEscapeF \__rubos_if_shell_escape:F
\cs_set_eq:NN\IfShellEscapeTF \__rubos_if_shell_escape:TF

\ExplSyntaxOff


% --Style Stuff--%

% Section Fonts
\setkomafont{section}{\large\bfseries\sffamily}
\setkomafont{subsection}{\normalsize\bfseries\sffamily}
\setkomafont{subsubsection}{\normalsize\bfseries\sffamily}

% Center Captions
\captionsetup[figure]{justification=centering}
\captionsetup[subfigure]{justification=centering}
\captionsetup[table]{justification=centering}

% Remove unwanted space from tables
\aboverulesep = 0mm \belowrulesep = 0mm

% Description-list styling.
\SetLabelAlign{parright}{\parbox[t]{\labelwidth}{\raggedleft#1}}
\setlist[description]{style = multiline, leftmargin = 4cm, align = parright,font=\mdseries}

\renewcommand*{\thetask}{%
  \texorpdfstring{}{H}%
  \arabic{task}%
}

\ExplSyntaxOn
\def\boxarc{\prop_item:Nn \g_ptxcd_template_opts_prop {boxarc}} % Used for Code Blocks, Info boxes, etc.

\ExplSyntaxOff

\renewcommand*{\taskformat}{H\thetask{}} % Taskprefix

% Point Formating
\renewcommand*{\creditformat}[1]{\hfill#1}
\renewcommand*{\subtaskformat}{\thetask{}\space\thesubtask\enskip}

% Define Glossary style
\ifthenelse{\isundefined{\printindex}}{}{
  \makeindex[
    columns=3,
    title=Stichwortverzeichnis,
    intoc,
    options=-s mystyle % Requires mystyle.ist, see repo
  ]
  %Fix indent for glossary
  \def\@idxitem{\par\hangindent 0pt}
}

% Advanced Styling
\ExplSyntaxOn

% Row Color
\bool_if:NT \g_ptxcd_ex_fancy_rowcolor_bool {
  \rowcolors{2}{\thepagecolor}{fgcolor!10!\thepagecolor}
}

\IfDarkModeT{\IfFileExists{tuda_logo_inverted.pdf}{\tl_gset:Nn \g_ptxcd_logofile_tl {tuda_logo_inverted.pdf}}{}}

\IfTudaciVersionBetweenTF{2.10}{2.11}{
  \cs_new:Nn \ptxcd_define_captionFallback:Nn {
    \providecommand*#1{
      \msg_warning:nnxxx{tudapub} {unknown-language}
      {\languagename} {\exp_not:N #1} {#2}
      \def#1{#2}
    }
  }
}{}

\cs_new:Nn \ptxcd_declare_caption:Nnnn {
  \ptxcd_define_captionFallback:Nn #1 {#2}
  \defcaptionname{ngerman, german}{#1}{#2}
  \defcaptionname{english, USenglish, american}{#1}{#3}
  \defcaptionname{UKenglish, british}{#1}{#4}
}

\cs_new:Nn \ptxcd_declare_caption:Nnn {
  \ptxcd_declare_caption:Nnnn #1 {#2} {#3} {#3}
}

\ptxcd_declare_caption:Nnn \authorandname {und} {and}

\newcommand*{\@contributor}{
  \begingroup
  \hyphenpenalty=100000
  \seq_use:Nnnn \g_ptxcd_contributor_seq {~\authorandname{}~} {,~} {~\&~}
  \endgroup
}
\renewcommand*{\@author}{
  \begingroup
  \hyphenpenalty=100000
  \IfTudaciVersionAtLeastTF{3.0}{
    \seq_use:Nnnn \g_ptxcd_author_seq {~\authorandname{}~} {,~} {~\&~}
  }{
    \seq_use:Nnnn \g_TUDa_author_seq {~\authorandname{}~} {,~} {~\&~}
  }
  \endgroup
}

\IfTudaciVersionAtLeastTF{3.0}{
  \renewcommand*{\@maketitle}{%
    % \maketerm{}% Might Move Term Creation here soon
    \global\@topnum=\z@
    \setparsizes{\z@}{\z@}{\z@\@plus 1fil}\par@updaterelative
    \vspace*{-\dim_eval:n {
        \headheight
        -\c_ptxcd_largerule_dim -\c_ptxcd_rulesep_dim
        +\headsep
        +\ht\strutbox
        +\p@
      }}
    \par
    \nointerlineskip
    \begingroup
    \setlength{\fboxsep}{\z@}
    \bool_if:NT \g_ptxcd_colorback_bool {\colorbox{accentcolor}}{\parbox[t]{\linewidth}{
        \rule{0pt}{\bool_if:NTF \g_ptxcd_smalltitle_bool {.25} {.5}\c_ptxcd_logoheight_dim}
        \par\nointerlineskip
        \raisebox{-\height}{%
          \begin{minipage}[t]{\dimexpr\linewidth-2.2\c_ptxcd_logoheight_dim-1ex}
            \bool_if:NT \g_ptxcd_colorback_bool  {\begin{addmargin}{3mm}}
                \raggedright
                \bool_if:NT \g_ptxcd_colorback_bool {\color{textonaccentcolor}}
                \tl_if_empty:NF \@titlehead {\usekomafont{titlehead}{\@titlehead\par}}
                \leavevmode\usekomafont{title}%
                {\usekomafont{title}\bool_if:NTF \g_ptxcd_smalltitle_bool {\LARGE} {\huge} {\@title\par}}%
                \vskip 1em
                \bool_if:NF \g_ptxcd_ex_compatibility_bool
                {
                  {\ifx\@subtitle\@empty\else\usekomafont{subtitle}\@subtitle\par\fi}%
                  \gdef\@subtitle{}
                  \vskip .5em
                }
                % Standart Author Position
                % {
                %   \xdef\@author {\@author}
                %   \ifx\@author\@empty\else\usekomafont{author}\@author\par\fi
                % }
                \vskip .5em
                \bool_if:NTF \g_ptxcd_colorback_bool {\end{addmargin}} {\par}
          \end{minipage}}
        \tl_if_empty:NF \g_ptxcd_logofile_tl {
          \hfill\raisebox{\dim_eval:n {
              \bool_if:NTF \g_ptxcd_colorback_bool
              {-\height}
              {-.9\c_ptxcd_logoheight_dim}
            }}
          [0pt]
          [\dim_eval:n {
              \bool_if:NTF \g_ptxcd_smalltitle_bool
              {\bool_if:NTF \g_ptxcd_colorback_bool {1.15}{1}}
              {\bool_if:NTF \g_ptxcd_colorback_bool {1.5}{1.3}
              }\c_ptxcd_logoheight_dim}]
          {\makebox[2.2\c_ptxcd_logoheight_dim][l]{\includegraphics[height=\c_ptxcd_logoheight_dim]{\g_ptxcd_logofile_tl}}}
        }
        \par\medskip
      }}
    \par
    \nointerlineskip
    \rule{\linewidth}{\g_ptxcd_titlerule_dim}
    % subtitle fields if not compat
    \exp_args:Nf \tl_if_empty:nF {\seq_use:Nnnn \g_ptxcd_author_seq {~\authorandname{}~} {,~} {~\&~}\seq_use:Nnnn \g_ptxcd_contributor_seq {~\authorandname{}~} {,~} {~\authorandname{}~}\g_ptxcd_ex_sheetnum_tl\@date\g_ptxcd_ex_term_tl\use:c {@subsubtitle}\@subtitle}{
      \par\nointerlineskip
      \bool_if:NT \g_ptxcd_colorback_bool {\colorbox{accentcolor}}{
        \parbox{\linewidth}{
          \begin{minipage}{\linewidth}
            \bool_if:NT \g_ptxcd_colorback_bool {
              \color{textonaccentcolor}
              \begin{addmargin}{3mm}
                }
                \null\par
                % Term
                \bool_if:NTF \g_manual_term_bool{
                  \g_ptxcd_ex_term_tl
                }
                {
                  \def\ptxcd_nextsep{}
                  \bool_gset_true:N \g_tmpa_left_bool
                  \clist_map_inline:Nn \g_ptxcd_ex_term_order_clist {
                    % Process different term Styles
                    \str_case_e:nnF {\g_ptxcd_ex_term_style_tl} {
                      {left} {
                          \tl_if_empty:cF {##1} {
                            \seq_put_right:cn {\bool_if:nTF \g_tmpa_left_bool {g_ptxcd_term_left_seq} {g_ptxcd_term_right_seq}} {\use:c {##1}}
                          }
                        }
                        {center} {
                          \tl_if_empty:cF {##1} {
                            \seq_put_right:cn {\bool_if:nTF \g_tmpa_left_bool {g_ptxcd_term_left_seq} {g_ptxcd_term_right_seq}} {\use:c {##1}}
                          }
                        }
                        {left-right} {
                          \tl_if_empty:cF {##1} {
                            \seq_put_right:cn {\bool_if:nTF \g_tmpa_left_bool {g_ptxcd_term_left_seq} {g_ptxcd_term_right_seq}} {\use:c {##1}}\bool_set:Nn \g_tmpa_left_bool {!\g_tmpa_left_bool}
                          }
                        }
                        {left-right-manual} {
                          % Do Nothing lol
                        }
                    }
                    {
                      \ClassError{rubos_tuda_template}{Unknown Term style Option: \use:c {\g_ptxcd_ex_term_style_tl}}{Available options are: left, center, left-right (default)}
                    }
                  }
                  % Left Side
                  \begin{minipage}[t]{\seq_if_empty:NF {\g_ptxcd_term_right_seq}{.6}\linewidth}
                    \str_if_eq:eeT{\g_ptxcd_ex_term_style_tl} {center} {\centering}
                    \seq_use:Nnnn \g_ptxcd_term_left_seq {\mbox{}\par} {\mbox{}\par} {\mbox{}\par}
                    \gdef\ptxcd_nextsep{\par}
                  \end{minipage}
                  \seq_if_empty:NF {\g_ptxcd_term_right_seq}{
                    \begin{minipage}[t]{.4\linewidth}
                      \raggedleft
                      \begin{flushright}
                        \seq_use:Nnnn \g_ptxcd_term_right_seq {\mbox{}\par} {\mbox{}\par} {\mbox{}\par}
                      \end{flushright}
                      \gdef\ptxcd_nextsep{\par}
                    \end{minipage}
                  }
                  % \vspace{-\abovedisplayskip}
                  \bool_if:nT { !\seq_if_empty_p:N \g_ptxcd_term_left_seq || !\seq_if_empty_p:N \g_ptxcd_term_right_seq } {
                    \vspace*{\lineskip}
                    \par
                  }
                  \tl_if_empty:NF \g_ptxcd_ex_term_tl {\g_ptxcd_ex_term_tl}
                  % \clist_map_inline:nn {@subtitle, @subsubtitle, g_ptxcd_ex_term_tl} {
                  %   \tl_if_empty:cF {##1} {\ptxcd_nextsep\use:c {##1}\def\ptxcd_nextsep{\\}}
                  % }
                  % \tl_if_empty:NF \g_ptxcd_ex_sheetnum_tl {\ptxcd_nextsep\sheetname\sheetsep\g_ptxcd_ex_sheetnum_tl}
                }

                \bool_if:NT \g_ptxcd_colorback_bool {\end{addmargin}}
          \end{minipage}
          \vspace*{\dp\strutbox}
        }}\par\nointerlineskip
      \rule{\linewidth}{\g_ptxcd_titlerule_dim}
    }
    \par
    \bool_if:NT  \g_ptxcd_headontitle_bool {
      \if@twoside
        \box_use:N \g_ptxcd_ex_headline_odd_box
      \else
        \box_use:N \g_ptxcd_ex_headline_oneside_box
      \fi
      \par
      \rule{\linewidth}{\g_ptxcd_titlerule_dim}
      \par
    }
    \endgroup
    \vskip 2em
    \ConfigureHeadline{}
  }%
}{

  \IfTudaciVersionBetweenTF{2.10}{2.11}{
    \renewcommand*{\@maketitle}{%
      \global\@topnum=\z@
      \setparsizes{\z@}{\z@}{\z@\@plus 1fil}\par@updaterelative
      \vspace*{-\dim_eval:n {
          \headheight
          -\c_TUDa_largerule_dim -\c_TUDa_rulesep_dim
          +\headsep
          +\ht\strutbox
          +\p@
        }}
      \par
      \nointerlineskip
      \raisebox{\dim_eval:n {
          -.5\c_TUDa_logoheight_dim
        }}[0pt][\dim_eval:n {\bool_if:NTF \g_TUDa_smalltitle_bool {.25} {.5}\c_TUDa_logoheight_dim}]{
        \bool_if:NT \g_TUDa_colorback_bool {\color{accentcolor}\rule{\linewidth}{.5\c_TUDa_logoheight_dim}}
      }
      \par\nointerlineskip
      \begingroup
      \setlength{\fboxsep}{\z@}
      \bool_if:NT \g_TUDa_colorback_bool {\colorbox{accentcolor}}{\parbox[t]{\linewidth}{
          \raisebox{-\height}{%
            \begin{minipage}[t]{\dimexpr\linewidth-2.2\c_TUDa_logoheight_dim-1ex}
              \bool_if:NT \g_TUDa_colorback_bool  {\begin{addmargin}{3mm}}
                  \raggedright
                  \bool_if:NT \g_TUDa_colorback_bool {\color{textonaccentcolor}}
                  \tl_if_empty:NF \@titlehead {\usekomafont{titlehead}{\@titlehead\par}}
                  \leavevmode\usekomafont{title}%
                  {\usekomafont{title}\bool_if:NTF \g_TUDa_smalltitle_bool {\LARGE} {\huge} {\@title\par}}%
                  \vskip 1em
                  \bool_if:NF \g_TUDa_ex_compatibility_bool
                  {
                    {\ifx\@subtitle\@empty\else\usekomafont{subtitle}\@subtitle\par\fi}%
                    \gdef\@subtitle{}
                    \vskip .5em
                  }
                  % {\ifx\@author\@empty\else\usekomafont{author}\@author\par\fi}%
                  \vskip .5em
                  \bool_if:NTF \g_TUDa_colorback_bool {\end{addmargin}} {\par}
            \end{minipage}}
          \tl_if_empty:NF \g_TUDa_logofile_tl {
            \hfill\raisebox{\dim_eval:n {
                \bool_if:NTF \g_TUDa_colorback_bool
                {-\height}
                {-.9\c_TUDa_logoheight_dim}
              }}
            [0pt]
            [\dim_eval:n {
                \bool_if:NTF \g_TUDa_smalltitle_bool
                {\bool_if:NTF \g_TUDa_colorback_bool {1.15}{1}}
                {\bool_if:NTF \g_TUDa_colorback_bool {1.5}{1.3}
                }\c_TUDa_logoheight_dim}]
            {\makebox[2.2\c_TUDa_logoheight_dim][l]{\includegraphics[height=\c_TUDa_logoheight_dim]{\g_TUDa_logofile_tl}}}
          }
          \par\medskip
        }}
      \par
      \nointerlineskip
      \rule{\linewidth}{\g_TUDa_titlerule_dim}
      % subtitle fields if not compat
      \exp_args:Nf \tl_if_empty:nF {\seq_use:Nnnn \g_TUDa_author_seq {~\authorandname{}~} {,~} {~\&~}\seq_use:Nnnn \g_ptxcd_contributor_seq {~\authorandname{}~} {,~} {~\authorandname{}~}\g_TUDa_ex_sheetnum_tl\@date\g_TUDa_ex_term_tl\use:c {@subsubtitle}\@subtitle}{
        \par\nointerlineskip
        \bool_if:NT \g_TUDa_colorback_bool {\colorbox{accentcolor}}{
          \parbox{\linewidth}{
            \begin{minipage}{\linewidth}
              \bool_if:NT \g_TUDa_colorback_bool {
                \color{textonaccentcolor}
                \begin{addmargin}{3mm}
                  }
                  \null\par
                  % Term
                  \bool_if:NTF \g_manual_term_bool{
                    \g_TUDa_ex_term_tl
                  }
                  {
                    \def\ptxcd_nextsep{}
                    \bool_gset_true:N \g_tmpa_left_bool
                    \clist_map_inline:Nn \g_TUDa_ex_term_tl {
                      % Process different term Styles
                      \str_case_e:nnF {\g_ptxcd_ex_term_style_tl} {
                        {left} {
                            \tl_if_empty:cF {##1} {
                              \seq_put_right:cn {\bool_if:nTF \g_tmpa_left_bool {g_ptxcd_term_left_seq} {g_ptxcd_term_right_seq}} {\use:c {##1}}
                            }
                          }
                          {center} {
                            \tl_if_empty:cF {##1} {
                              \seq_put_right:cn {\bool_if:nTF \g_tmpa_left_bool {g_ptxcd_term_left_seq} {g_ptxcd_term_right_seq}} {\use:c {##1}}
                            }
                          }
                          {left-right} {
                            \tl_if_empty:cF {##1} {
                              \seq_put_right:cn {\bool_if:nTF \g_tmpa_left_bool {g_ptxcd_term_left_seq} {g_ptxcd_term_right_seq}} {\use:c {##1}}\bool_set:Nn \g_tmpa_left_bool {!\g_tmpa_left_bool}
                            }
                          }
                          {left-right-manual} {
                            % Do Nothing lol
                          }
                      }
                      {
                        \ClassError{rubos_tuda_template}{Unknown Term style Option: \use:c {\g_ptxcd_ex_term_style_tl}}{Available options are: left, center, left-right (default)}
                      }
                    }
                    % Left Side
                    \begin{minipage}[t]{\seq_if_empty:NF {\g_ptxcd_term_right_seq}{.6}\linewidth}
                      \str_if_eq:eeT{\g_ptxcd_ex_term_style_tl} {center} {\centering}
                      \seq_use:Nnnn \g_ptxcd_term_left_seq {\mbox{}\\} {\mbox{}\\} {\mbox{}\\}
                      \gdef\ptxcd_nextsep{\\}
                    \end{minipage}
                    \seq_if_empty:NF {\g_ptxcd_term_right_seq}{
                      \begin{minipage}[t]{.4\linewidth}
                        \raggedleft
                        \begin{flushright}
                          \seq_use:Nnnn \g_ptxcd_term_right_seq {\mbox{}\\} {\mbox{}\\} {\mbox{}\\}
                        \end{flushright}
                        \gdef\ptxcd_nextsep{\\}
                      \end{minipage}
                      \tl_if_empty:NF \g_TUDa_ex_term_tl {\ptxcd_nextsep\g_TUDa_ex_term_tl}
                    }
                    % \clist_map_inline:nn {@subtitle, @subsubtitle, g_ptxcd_ex_term_tl} {
                    %   \tl_if_empty:cF {##1} {\ptxcd_nextsep\use:c {##1}\def\ptxcd_nextsep{\\}}
                    % }
                    % \tl_if_empty:NF \g_TUDa_ex_sheetnum_tl {\ptxcd_nextsep\sheetname\sheetsep\g_TUDa_ex_sheetnum_tl}
                  }
                  \bool_if:NT \g_TUDa_colorback_bool {\end{addmargin}}
            \end{minipage}
            \vspace*{\dp\strutbox}
          }}\par\nointerlineskip
        \rule{\linewidth}{\g_TUDa_titlerule_dim}
      }
      \par
      \bool_if:NT  \g_TUDa_headontitle_bool {
        \if@twoside
          \box_use:N \g_TUDa_ex_headline_odd_box
        \else
          \box_use:N \g_TUDa_ex_headline_oneside_box
        \fi
        \par
        \rule{\linewidth}{\g_TUDa_titlerule_dim}
        \par
      }
      \endgroup
      \vskip 2em
      \ConfigureHeadline{}
    }%
  }{
    \ClassError{rubos-tuda-template}{Tu-Template~Version~zu~alt.}{Bitte~die~neuste~tuda-ci~Version~installieren.}
  }

}


% Better Task Titles
\IfTudaciVersionAtLeastTF{3.13}{
  \renewcommand*\sectionlinesformat[4]{%
    \parbox{\linewidth}{
      \bool_if:cT {g__ptxcd_ruled_#1_bool} {
        \rule[5\g_ptxcd_titlerule_dim]{\linewidth}{\g_ptxcd_titlerule_dim}\par\nointerlineskip
      }
      \@hangfrom{%
        \hskip #2#3}{
        \tl_if_eq:nnT {#1} {task} {
          \exp_args:No \tl_if_empty:nF {#4}
          {:~}
          \bool_if:NT \l__ptxcd_points_auto_bool {
            \exp_args:NNx \prop_get:NnN \g__ptxcd_loaded_points_prop {\thetask} \l_ptxcd_tmp_tl
            \quark_if_no_value:NF \l_ptxcd_tmp_tl {
              \fp_set:Nn \l_ptxcd_ex_task_points_fp {\l_ptxcd_tmp_tl}
            }
          }
        }
        {#4\ensuremath{\vcenter{\hbox{\tikz{\node[inner\space sep=0pt, text\space height=1.1em]{};}}}}}% Übungstitel mit Seriefen
        \tl_if_in:nnT {#1} {task} {
          \tl_if_empty:cTF{l_ptxcd_ex_#1_credit_tl}
          {\pointformat{\fp_to_decimal:c {l_ptxcd_ex_#1_points_fp}}}
          {\creditformat{\tl_use:c {l_ptxcd_ex_#1_credit_tl}}}
        }
        \rule[-\dp\strutbox]{0pt}{\dp\strutbox}\par}\nointerlineskip
      \skip_vertical:n {\ptxcd_titlerule_sep: -\dp\strutbox}
      \bool_if:cT {g__ptxcd_ruled_#1_bool} {\smash{\rule{\linewidth}{\g_ptxcd_titlerule_dim}}}
    }}
}{}


\newcommand*{\numberFormBox}[1]{
  \rule{\fboxrule}{1ex}
  \tikz[overlay,baseline=.1ex,anchor=south\space west]{\node[inner\space sep=0pt, minimum\space size=1em] at(0,0){#1};}
  \rule{1em}{\fboxrule}
  \rule{\fboxrule}{1ex}
  \,
}

% Custom Headline Style
\clist_map_inline:nn {odd, even, oneside} {
  \keys_define:nn {ptxcd/exercise/headline} {
    #1 .choice:,
    #1 / aud .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
      \textbf{\g_ptxcd_shorttitle_tl}\tl_if_empty:NF \g_ptxcd_ex_semester_tl {\space{}im\space\textbf{\g_ptxcd_ex_semester_tl}}\tl_if_empty:NF \g_ptxcd_ex_dozent_tl {\space{}bei\space\textbf{\g_ptxcd_ex_dozent_tl}}\tl_if_empty:NF \g_ptxcd_ex_sheetnum_tl {\hfill Übungsblatt\space{}\padzeroes[2]{\g_ptxcd_ex_sheetnum_tl}}\par
      \StudentNamename\StudentNamesep\IfSolutionT{\rlap{\textbf{\textsf{~Musterlösung}}}}\hrulefill\qquad\StudentIDname\StudentIDsep\prg_replicate:nn {7} {\numberFormBox{\IfSolutionT{\textbf{\textsf{0}}}}}},
    #1 / submittors-detailed .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} { % Diese Option ist eher für Einzelabgaben gedacht, da sie sonst sehr viel Platz weg nimmt
      \textbf{\g_ptxcd_shorttitle_tl}\tl_if_empty:NF \g_ptxcd_ex_semester_tl {\space{}im\space\textbf{\g_ptxcd_ex_semester_tl}}\tl_if_empty:NF \g_ptxcd_ex_dozent_tl {\space{}bei\space\textbf{\g_ptxcd_ex_dozent_tl}}\hfill Übungsblatt\space{}\padzeroes[2]{\g_ptxcd_ex_sheetnum_tl}\par
      \gdef\ptxcd_nextsep_submittors{}
      \seq_map_inline:Nn \g_ptxcd_submittors_seq {
        \ptxcd_nextsep_submittors Name\StudentNamesep\hrulefill ####1\hrulefill\qquad\StudentIDname\StudentIDsep \exp_args:Nx\str_map_inline:Nn {\getMatrikelnummer{####1}} {\numberFormBox{########1}}\gdef\ptxcd_nextsep_submittors{\par}
      }
    },
    #1 / submittors-semi-detailed .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} { % Diese Option ist eher für Einzelabgaben gedacht, da sie sonst sehr viel Platz weg nimmt
      \textbf{\g_ptxcd_shorttitle_tl}\tl_if_empty:NF \g_ptxcd_ex_semester_tl {\space{}im\space\textbf{\g_ptxcd_ex_semester_tl}}\tl_if_empty:NF \g_ptxcd_ex_dozent_tl {\space{}bei\space\textbf{\g_ptxcd_ex_dozent_tl}}\hfill Übungsblatt\space{}\padzeroes[2]{\g_ptxcd_ex_sheetnum_tl}\par
      \seq_if_empty:NF\g_ptxcd_submittors_seq {\textbf{Abgabe\space{}von:}\space
        \seq_use:Nnnn \g_ptxcd_submittors_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}
    },
    #1 / submittors .code:n = {\tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
          \textbf{\textsf{\g_ptxcd_shorttitle_tl\space{}Abgabe}}\seq_if_empty:NF\g_ptxcd_submittors_seq {\textbf{\textsf{\space{}von:}}\space
            \seq_use:Nnnn \g_ptxcd_submittors_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}
        }},
    #1 / submittors-centered .code:n = {\tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
          \centering\textbf{\textsf{\g_ptxcd_shorttitle_tl\space{}Abgabe}}\seq_if_empty:NF\g_ptxcd_submittors_seq {\textbf{\textsf{\space{}von:}}\space
            \seq_use:Nnnn \g_ptxcd_submittors_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}
        }},
    #1 / summary-centered .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {%
      \centering\textbf{\sffamily\g_ptxcd_shorttitle_tl\space{}Zusammenfassung}\space{}von\space{}\seq_use:Nnnn \g_ptxcd_author_seq {~\authorandname{}~} {,~} {~\authorandname{}~}},
    #1 / unknown .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {##1}
  }
}
\clist_map_inline:nn {odd, even, oneside} {
\keys_define:nn {TUDa/exercise/headline} {
#1 .choice:,
#1 / aud .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {
\textbf{\g_TUDa_shorttitle_tl}\tl_if_empty:NF \g_ptxcd_ex_semester_tl {\space{}im\space\textbf{\g_ptxcd_ex_semester_tl}}\tl_if_empty:NF \g_ptxcd_ex_dozent_tl {\space{}bei\space\textbf{\g_ptxcd_ex_dozent_tl}} \tl_if_empty:NF g_TUDa_ex_sheetnum_tl {\hfill Übungsblatt\space{}\padzeroes[2]{\g_TUDa_ex_sheetnum_tl}}\par
\StudentName\StudentID},
#1 / submittors-detailed .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} { % Diese Option ist eher für Einzelabgaben gedacht, da sie sonst sehr viel Platz weg nimmt
  \textbf{\g_TUDa_shorttitle_tl}\tl_if_empty:NF \g_ptxcd_ex_semester_tl {\space{}im\space\textbf{\g_ptxcd_ex_semester_tl}}\tl_if_empty:NF \g_ptxcd_ex_dozent_tl {\space{}bei\space\textbf{\g_ptxcd_ex_dozent_tl}}\hfill Übungsblatt\space{}\padzeroes[2]{\g_TUDa_ex_sheetnum_tl}\par
  \gdef\ptxcd_nextsep_submittors{}
  \seq_map_inline:Nn \g_ptxcd_submittors_seq {
    \ptxcd_nextsep_submittors Name\StudentNamesep\hrulefill ####1\hrulefill\qquad\StudentIDname\StudentIDsep \exp_args:Nx\str_map_inline:Nn {\getMatrikelnummer{####1}} {\numberFormBox{########1}}\gdef\ptxcd_nextsep_submittors{\par}
  }
},
#1 / submittors-semi-detailed .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} { % Diese Option ist eher für Einzelabgaben gedacht, da sie sonst sehr viel Platz weg nimmt
  \textbf{\g_TUDa_shorttitle_tl}\tl_if_empty:NF \g_ptxcd_ex_semester_tl {\space{}im\space\textbf{\g_ptxcd_ex_semester_tl}}\tl_if_empty:NF \g_ptxcd_ex_dozent_tl {\space{}bei\space\textbf{\g_ptxcd_ex_dozent_tl}}\hfill Übungsblatt\space{}\padzeroes[2]{\g_TUDa_ex_sheetnum_tl}\par
  \seq_if_empty:NF\g_ptxcd_submittors_seq {\textbf{Abgabe\space{}von:}\space
    \seq_use:Nnnn \g_ptxcd_submittors_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}
},
#1 / submittors .code:n = {\tl_gset:cn {g_TUDa_ex_headline_#1_tl} {
      \textbf{\textsf{\g_TUDa_shorttitle_tl\space{}Abgabe}}\seq_if_empty:NF\g_ptxcd_submittors_seq {\textbf{\textsf{\space{}von:}}\space
        \seq_use:Nnnn \g_ptxcd_submittors_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}
    }},
#1 / submittors-centered .code:n = {\tl_gset:cn {g_TUDa_ex_headline_#1_tl} {
      \centering\textbf{\textsf{\g_TUDa_shorttitle_tl\space{}Abgabe}}\seq_if_empty:NF\g_ptxcd_submittors_seq {\textbf{\textsf{\space{}von:}}\space
        \seq_use:Nnnn \g_ptxcd_submittors_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}
    }},
#1 / summary-centered .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {%
  \centering\textbf{\sffamily\g_TUDa_shorttitle_tl\space{}Zusammenfassung}\space{}von\space{}\seq_use:Nnnn \g_TUDa_author_seq {~\authorandname{}~} {,~} {~\authorandname{}~}},
#1 / unknown .code:n = \tl_gset:cn {g_TUDa_ex_headline_#1_tl} {##1}
}
}

\ExplSyntaxOff

% --Environments and Boxes--

% definition Environment Style
\newtheoremstyle{mydefinition}% Theorem style name
{0pt}% Space above
{0pt}% Space below
{\normalfont}% Body font
{}% Indent amount
{\small\bfseries\sffamily\color{accentcolor}}% Theorem head font
{\;}% Punctuation after theorem head
{0.25em}% Space after theorem head
{
  \small\sffamily\color{accentcolor}\thmname{#1}% Theorem text (e.g. Theorem 2.1)
  \thmnote{\space\sffamily\bfseries\color{fgcolor}---\space#3}% Optional theorem note
}

% A Gray Info Box (gray bar on the Left+ light gray background)
\newtcolorbox{grayInfoBox}[1][]{
  colback=\IfDarkModeTF{white!10!black}{gray!10}, %Hintergrundfarbe
  % colback=fgcolor!10!\thepagecolor, %Hintergrundfarbe
  coltext=.,
  colframe=gray, % Randfarbe
  frame hidden,
  title style=black!80,
  arc=\boxarc,
  boxrule=0pt,
  left=5pt, % Links Platz lassen
  enhanced, % Erlaubt uns, den ramen zu zeichnen
  fonttitle=\sffamily, % Titelschriftart auf 
  overlay={ % Für Grauen Bereich links
      \begin{tcbclipinterior}
        \fill[gray] (frame.south west) rectangle ([xshift=4pt]frame.north west); % Zeilennummernbereich färben
      \end{tcbclipinterior}
    },
  #1 % Weitere Argumente zulassen
}

% A Normal Information Box (Accentcolor bar on the left)
\newtcolorbox{infoBox}[1][]{
  colback=\thepagecolor, %Hintergrundfarbe
  colframe=accentcolor, % Randfarbe
  coltext=.,
  frame hidden,
  title style=gray,
  arc=\boxarc,
  boxrule=0pt,
  left=5pt, % Links Platz lassen
  enhanced, % Erlaubt uns, den ramen zu zeichnen
  fonttitle=\sffamily, % Titelschriftart auf 
  overlay={ % Für Grauen Bereich links
      \begin{tcbclipinterior}
        \fill[accentcolor] (frame.south west) rectangle ([xshift=4pt]frame.north west); % Zeilennummernbereich färben
      \end{tcbclipinterior}
    },
  #1 % Weitere Argumente zulassen
}

% An Important Information Box (Accentcolor bar on the left+ light Accentcolor BG)
\newtcolorbox{defBox}[1][]{
  colback=\IfDarkModeTF{accentcolor!20!\thepagecolor}{accentcolor!10!\thepagecolor}, %Hintergrundfarbe
  colframe=accentcolor, % Randfarbe
  coltext=.,
  frame hidden,
  title style=accentcolor,
  arc=\boxarc,
  boxrule=0pt,
  left=5pt, % Links Platz lassen
  enhanced, % Erlaubt uns, den ramen zu zeichnen
  fonttitle=\sffamily, % Titelschriftart auf 
  overlay={ % Für Grauen Bereich links
      \begin{tcbclipinterior}
        \fill[accentcolor] (frame.south west) rectangle ([xshift=4pt]frame.north west); % Zeilennummernbereich färben
      \end{tcbclipinterior}
    },
  #1 % Weitere Argumente zulassen
}

% Box like The one Used for Code Blocks, just without Code Block
\newtcolorbox{normalBox}[1][]{%
  colback=fgcolor!10!\thepagecolor, %Hintergrundfarbe
  colframe=black!70, % Randfarbe
  coltext=.,
  boxrule=0pt,
  frame hidden,
  title style=black!70,
  arc=\boxarc,
  left=5pt, % Links Platz lassen
  enhanced, % Erlaubt uns, den ramen zu zeichnen
  fonttitle=\sffamily, % Titelschriftart auf 
  #1 % Weitere Argumente zulassen
}

% Definition Environment
\theoremstyle{mydefinition}%
\newtheorem{definitionT}{\textsf{Definition}}%
\newtheorem{ideaT}{\textsf{Idee}}%
\newenvironment{definition}{\begin{defBox}\begin{definitionT}}{\end{definitionT}\end{defBox}}%
\newenvironment{idea}{\begin{defBox}\begin{ideaT}}{\end{ideaT}\end{defBox}}%

\IfShellEscapeTF{
  % Minted Line Number Styling
  \renewcommand{\theFancyVerbLine}{\tikz{\coordinate(a);\node[text width=5mm,inner sep=0pt,align=center]{\ttfamily\textcolor{white}{\scriptsize\arabic{FancyVerbLine}}};}}

  % Environment für meinen Style (Arg 1 = minted Options, Arg 2 = tcolorbox Options)
  \newtcblisting{codeBlock}[2][]{
    listing engine=minted, % Minted verwenden
    colback=\IfDarkModeTF{codebg}{fgcolor!10!\thepagecolor}, %Hintergrundfarbe
    colframe=black!70, % Randfarbe
    coltext=.,
    listing only,  % Sonst will er den Plain Text nach dem Minted Listing noch anfügen
    frame hidden,
    boxrule=0pt,
    arc=\boxarc,
    %hbox, % This option could be used to limit the Length of Code Blocks automatically, but does not work with the minted Line Numbers
    title style=\IfDarkModeTF{accentcolor!60!black}{black!90},
    minted style=\IfDarkModeTF{paraiso-dark}{default}, %Sieht actually worse aus imo
    minted language=java, % Sprache setzen
    minted options={ %Minted Optionen
        linenos=true,
        numbersep=3mm,
        texcl=true,
        #1 % weitere optionen für Minted zulassen
      },
    left=7.1mm, % Links Platz lassen
    enhanced, % Erlaubt uns, den ramen zu zeichnen
    fonttitle=\sffamily, % Titelschriftart auf 
    overlay={ % Für Grauen Bereich links
        \begin{tcbclipinterior}
          \fill[black!70] (frame.south west) rectangle ([xshift=5mm]frame.north west); % Zeilennummernbereich färben
        \end{tcbclipinterior}
      },
    #2 % Weitere Argumente zulassen
  }
}{
  \lstnewenvironment{codeBlock}[2][]{}{}%
}


\lstloadlanguages{Java}
\lstset{
  basicstyle=\footnotesize\ttfamily,
  keywordstyle=\IfDarkModeTF{\color{cyan!70!blue}}{\color{blue}},
  stringstyle=\color{red},
  commentstyle=\color{green!50!black},
  showstringspaces=false,
  breaklines,
  breakatwhitespace,
  keepspaces,
  numbers=left,
  numberstyle=\tiny,
  numbersep=5pt,
  backgroundcolor=\color{black!10},
  frame=single
}
\lstdefinestyle{java}{
  language=Java,
  moredelim=[is][\textcolor{gray}]{\#|}{|\#},
  moredelim=[is][\underline]{\#|!}{|\#}
}

% --Makros--
\newenvironment*{cpenumerate}[1][]{\begin{enumerate}[nosep, #1]}{\end{enumerate}}
% \newcommand{\code}[2][java]{\mintinline{#1}{#2}}
\IfShellEscapeTF{
  \usemintedstyle{borland}
  \newmintinline[code]{java}{fontsize=\footnotesize}
}{
  \newcommand{\code}[1]{{\texttt{\footnotesize #1}}}
}
\ExplSyntaxOn
\newcommand{\refexercise}[1]{
  \int_gzero_new:N \g_ptxcd_tmp_int
  \int_gset:Nn \g_ptxcd_tmp_int {\value{task}}
  \setcounter{task}{\getrefnumber{#1}}
  \hyperref[#1]{\taskformat}
  \setcounter{task}{\int_use:N \g_ptxcd_tmp_int}
}

\newcommand{\includeinvertablegraphics}[2][]{% Grafik wird beim Dark Mode automatisch Invertiert (rgb)
  \IfDarkModeTF{\includegraphics[decodearray={1.0~0.0~1.0~0.0~1.0~0.0},#1]{#2}}{\includegraphics[#1]{#2}}
}
\newcommand{\includeinvertablegrayscalegraphics}[2][]{% Grafik wird beim Dark Mode automatisch Invertiert (grayscale)
  \IfDarkModeTF{\includegraphics[decodearray={1.0~0.0},#1]{#2}}{\includegraphics[#1]{#2}}
}

\newcommand{\setextlblprefix}[1]{
  \tl_if_empty:cTF {#1} {
    \tl_gset:Nn \g_rubos_external_label_prefix_tl {ext:}
    } {
      \tl_gset:Nn \g_rubos_external_label_prefix_tl {#1}
  }
}

% References from external Files
\newcommand{\extref}[2][\g_rubos_external_label_prefix_tl]{
  \bool_if:NTF \g_is_main_file_bool {
    \ref{#2}
  } {
    \ref{#1#2}
  }
}
\NewDocumentCommand\exthyperref{oO{\g_rubos_external_label_prefix_tl}m}{
  \bool_if:NTF \g_is_main_file_bool {
    \hyperref[#1]{#3}
  } {
    \hyperref[#2#1]{#3}
  }
}
\ExplSyntaxOff
\newcommand{\raisedcode}[1]{\raisebox{.1em}{\code{#1}}}
\newcommand{\bluecode}[1]{\code{\textcolor{\IfDarkModeTF{cyan}{blue}}{#1}}}
\newcommand{\red}[1]{\textcolor{red}{#1}}
\newcommand{\fatsf}[1]{\textbf{\textsf{#1}}}
\newcommand{\fatit}[1]{\textbf{\textit{#1}}}
\newcommand{\gegeben}{\textbf{\textsf{Gegeben: }}}
\newcommand{\gesucht}{\textbf{\textsf{Gesucht: }}}
\newcommand{\zuzeigen}{\textbf{\textsf{Zu zeigen: }}}
\newcommand{\zuberechnen}{\textbf{\textsf{Zu berechnen: }}}
\newcommand{\zubestimmen}{\textbf{\textsf{Zu bestimmen: }}}
\newcommand{\anzugeben}{\textbf{\textsf{Anzugeben: }}}
\newcommand{\loesung}{\textbf{\textsf{Lösung: }}}
\newcommand{\antwort}{\textbf{\textsf{Antwort: }}}
\newcommand{\rechnung}{\textbf{\textsf{Rechnung: }}}
\newcommand{\fakebullet}{~\raisebox{-.2\height}{\llap{\textbullet}}~}
\newcommand{\fakebullett}{~\llap{-}~}
\newcommand{\fakebullettt}{~\llap{*}~}
\newcommand{\mlcell}[2][l]{\Gape[0pt][2pt]{\makecell[#1]{#2}}}
\newcommand{\toprighttreemark}[1]{{\node[inner sep=0pt] at (.north east) [xshift=.2cm,yshift=.2cm] {#1};}}
\newcommand{\toplefttreemark}[1]{{\node[inner sep=0pt] at (.north west) [xshift=-.2cm,yshift=.2cm] {#1};}}
\newcommand{\toptreemark}[1]{{\node[inner sep=0pt] at (.north) [yshift=.2cm] {#1};}}
\newcommand{\toppointer}[1]{{\node[inner sep=0pt] (lbl) at (.north) [yshift=1cm] {\textcolor{orange}{#1}}; \draw[->,orange] (lbl.south) -- (.north);}}
\newcommand{\shorttoppointer}[1]{{\node[inner sep=0pt] (lbl) at (.north) [yshift=6mm] {\textcolor{orange}{#1}}; \draw[->,orange] (lbl.south) -- (.north);}}
\newcommand{\toprightpointer}[1]{{\node[inner sep=0pt] (lbl) at (.north) [xshift=.3cm,yshift=.8cm] {\textcolor{orange}{#1}}; \draw[->,orange] ($(lbl.south)-(.05cm,0)$) -- ($(.north)+(.1cm,-.15mm)$);}}
\newcommand{\topleftpointer}[1]{{\node[inner sep=0pt] (lbl) at (.north) [xshift=-.3cm,yshift=.8cm] {\textcolor{orange}{#1}}; \draw[->,orange] ($(lbl.south)+(.05cm,0)$) -- ($(.north)-(.1cm,.15mm)$);}}
\newcommand{\inlinejava}[1]{\lstinline[style=java]{#1}} % Wie in FOP- und AuD
\newcommand{\hyraisedlink}[1]{\Hy@raisedlink{\hypertarget{#1}{}}}
% Boxes surrounded by borders for information and warnings.
\newcommand{\info}[1]{%
  \begin{defBox}%
    #1
  \end{defBox}
}
\newcommand{\warning}[1]{
    \begin{defBox}
      \fatsf{Warnung:} #1
    \end{defBox}
}
% Workarounds and similar stuff.
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}

% Colors

%Color Definitions
\definecolor{bashcodebg}{rgb}{0.85,0.85,0.85}
\definecolor{tablegreen}{RGB}{207, 228, 174}
\definecolor{tablered}{RGB}{255, 191, 191}
\definecolor{tableyellow}{RGB}{255, 250, 193}
\definecolor{tableblue}{RGB}{107, 207, 246}
\definecolor{arrowgreen}{RGB}{0, 165, 79}
\definecolor{clight2}{RGB}{212, 237, 244}
\definecolor{codegreen}{rgb}{0,0.6,0}
\definecolor{codegray}{rgb}{0.5,0.5,0.5}
\definecolor{codepurple}{rgb}{0.58,0,0.82}
\definecolor{backcolour}{rgb}{0.95,0.95,0.92}
\definecolor{codebg}{RGB}{22,43,58}
\colorlet{fgcolor}{.}
\newcommand{\resetrc}{\global\rownum=0\relax} % T#
\newcommand{\continuerc}{\global\rownum=\numexpr\rownum - 1\relax} % T#
