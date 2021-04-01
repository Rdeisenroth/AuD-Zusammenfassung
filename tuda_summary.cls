\def\fileversion{1.00}
\def\filedate{2020/12/05}

% Sets the LaTeX version for the package to work.
\NeedsTeXFormat{LaTeX2e}
% Identification of the class and its date and version.
\ProvidesClass{tuda_summary} [Zusammenfassungsvorlage basierend auf TuDaExercise]

% Packages that need to be loaded before TUDA-Exercise Class
\RequirePackage[table]{xcolor} % Option has to be set before loading TuDaExercise
\RequirePackage{pagecolor} % Used for dark Mode
\RequirePackage{scrlfile}
\RequirePackage[table]{xcolor}
% Wir müssen imakeidx vor Hyperref laden, damit das Stichwortverzeichnis hyperlinks hat
\AfterClass{scrartcl}{
  \RequirePackage{imakeidx}
  \RequirePackage{xr-hyper}
}
\ExplSyntaxOn
\bool_gset_false:N \g_dark_mode_bool
\bool_gset_false:N \g_manual_term_bool
\bool_gset_false:N \g_is_summary_bool
\bool_gset_false:N \g_ptxcd_ex_load_common_bool
\bool_gset_true:N \g_ptxcd_ex_fancy_rowcolor_bool
\tl_gclear_new:N \datename
\tl_gset:Nn \datename {Datum}
\DeclareOption{dark_mode}{\pagecolor{black}\color{white}\bool_gset_true:N \g_dark_mode_bool}
\DeclareOption{manual_term}{\bool_gset_true:N \g_manual_term_bool}
\DeclareOption{summary}{\bool_gset_true:N \g_is_summary_bool\tl_gset:Nn \datename {Stand}}
\DeclareOption{load_common}{\bool_gset_true:N \g_ptxcd_ex_load_common_bool}
\DeclareOption{default_row_color}{\bool_gset_false:N \g_ptxcd_ex_fancy_rowcolor_bool}
\DeclareStringOption[4pt]{boxarc}[2pt]
\ExplSyntaxOff
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{tudaexercise}}
\ProcessOptions\relax
\ProcessKeyvalOptions{boxarc}\relax
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
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,minted}
\RequirePackage{totcount}
\regtotcounter{task}
\RequirePackage{wrapfig}

% Strings/Names
\renewcaptionname*{ngerman}{\solutionname}{Lösung}

% --Helper Commands--


\ExplSyntaxOn

% \newcommand{\loadcommon}{
  \bool_if:NT \g_ptxcd_ex_load_common_bool {
    % \pagecolor{black}\color{white}
    \RequirePackage{adjustbox}
    \RequirePackage{amssymb}
    \RequirePackage[ngerman]{babel}
    \RequirePackage{blindtext}
    \RequirePackage{colortbl}
    % \RequirePackage{cryptocode}
    \RequirePackage[utf8]{inputenc} % Has to be loaded before csquotes
    \RequirePackage{csquotes}
    \RequirePackage{ebproof}
    \RequirePackage{etoolbox}
    \RequirePackage[T1]{fontenc}
    \RequirePackage{forest}
    \RequirePackage{framed}
    \RequirePackage{import}
    % \RequirePackage[utf8]{inputenc} % Already loaded before cs quotes
    \RequirePackage{karnaughmap}
    \RequirePackage{latexsym}
    \RequirePackage{listings}
    \RequirePackage{longtable}
    \RequirePackage{makecell}
    \RequirePackage[framemethod=tikz]{mdframed}
    \RequirePackage{mleftright}
    \RequirePackage[longtable]{multirow}
    \RequirePackage{nccmath}
    \RequirePackage{placeins}
    \RequirePackage{proof}
    \RequirePackage{ragged2e}
    \RequirePackage{stackengine}
    \RequirePackage{standalone}
    \RequirePackage{tabularx}
    \RequirePackage{tikz}
    \ExplSyntaxOff % Tikz doesn't Like Expl3 :/
    \usetikzlibrary{patterns, shapes, intersections, arrows, math, decorations,decorations.pathreplacing, decorations.pathmorphing, positioning, calc, automata, chains, matrix, arrows.meta, shapes.geometric, shadows.blur, shapes.symbols, backgrounds, tikzmark, angles}
    \ExplSyntaxOn

    % \RequirePackage{tikz-uml}
    \RequirePackage{xifthen}
  }
% }
% \loadcommon{}

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

% Term Creation (Information Area below the Title)
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

\ExplSyntaxOff

% --Document Settings-- %

\ExplSyntaxOn

% Sheet number
\newcommand*{\getSheetnumber}{\g_ptxcd_ex_sheetnum_tl}
\newcommand*{\printSheetNumber}{\tl_if_empty:NF \g_ptxcd_ex_sheetnum_tl {\sffamily\textbf{Übungsblatt\space{}Nummer:}\space\padzeroes{\getSheetnumber}}}

% Sheet Version
\tl_new:N \g_ptxcd_ex_sheetver_tl
\tl_gclear_new:N \printVersion
\newcommand*{\version}[1]{
  \tl_gset:Nn \g_ptxcd_ex_sheetver_tl {#1}
  \tl_if_empty:NF \g_ptxcd_ex_sheetver_tl {\tl_gset:Nn \printVersion {\sffamily\textbf{v\getVersion}}}
}
\newcommand*{\getVersion}{\g_ptxcd_ex_sheetver_tl}

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
\newcommand*{\getShortTitle}{\g_ptxcd_shorttitle_tl}

% Author
\newcommand*{\printAuthor}{
  \seq_if_empty:NF \g_ptxcd_author_seq {\textbf{\textsf{\int_compare:nTF{\seq_count:N \g_ptxcd_author_seq > 1}{Authoren}{Author}:~}}\seq_use:Nnnn \g_ptxcd_author_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}
}

% Contributors
\newcommand*{\printContributor}{
  \seq_if_empty:NF \g_ptxcd_contributor_seq {\textbf{\textsf{Helfer:~}}\seq_use:Nnnn \g_ptxcd_contributor_seq {~\authorandname{}~} {,~} {~\authorandname{}~}}
}

% Date
\tl_gclear_new:N \printDate
\renewcommand*{\date}[1]{
  \tl_gset:Nn \@date {#1}
  \tl_if_empty:NF \@date {\tl_gset:Nn \printDate {\textsf{\textbf{\datename{}:~}}\@date}}
}
% \newcommand*{\printDate}{
%   \tl_if_empty:NF \@date {\textbf{\textsf{Datum:~}}\@date}
% }

% Modify GetPoints Command to work with makros
\renewcommand{\getPoints}[1]{
  \exp_args:NNx \prop_get:NnNTF \g__ptxcd_loaded_points_prop {#1} \l_tmpa_tl
  {\l_tmpa_tl}
  {\nfss@text{\reset@font\bfseries??}}
}

\clist_new:N \g_ptxcd_ex_term_order_clist
\clist_gset:Nn \g_ptxcd_ex_term_order_clist {printAuthor,printSemester,printContributor,printVersion,quad,quad,printDate,printFachbereich}
\newcommand*{\termOrder}[1]{\tl_gset:Nn \g_ptxcd_ex_term_order_clist {#1}}


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
  \arabic{task}
}

\ExplSyntaxOn
\def\boxarc{\use:c {tuda_summary@boxarc}} % Used for Code Blocks, Info boxes, etc.

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

\bool_if:NTF \g_dark_mode_bool
{\IfFileExists{tuda_logo_inverted.pdf}{\tl_gset:Nn \g_ptxcd_logofile_tl {tuda_logo_inverted.pdf}}{}}
{}

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

\seq_new:N \g_ptxcd_contributor_seq

\newcommand*\contributor[1]{
  \seq_gset_split:Nnn \g_ptxcd_contributor_seq {\and} {#1}
}

\newcommand*{\@contributor}{
  \begingroup
  \hyphenpenalty=100000
  \seq_use:Nnnn \g_ptxcd_contributor_seq {~\authorandname{}~} {,~} {~\&~}
  \endgroup
}
\renewcommand*{\@author}{
  \begingroup
  \hyphenpenalty=100000
  \seq_use:Nnnn \g_ptxcd_author_seq {~\authorandname{}~} {,~} {~\&~}
  \endgroup
}

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
                \seq_clear_new:N \g_tmpa_left_seq
                \seq_clear_new:N \g_tmpa_right_seq
                % \clist_if_empty:NTF \g_ptxcd_ex_term_order_clist {true} {false}
                % \clist_map_inline:Nn \g_ptxcd_ex_term_order_clist {##1 +}
                % \clist_count:N \g_ptxcd_ex_term_order_clist
                \clist_map_inline:Nn \g_ptxcd_ex_term_order_clist {
                  \tl_if_empty:cF {##1} {
                    \seq_put_right:cn {\bool_if:nTF \g_tmpa_left_bool {g_tmpa_left_seq} {g_tmpa_right_seq}} {\use:c {##1}}\bool_set:Nn \g_tmpa_left_bool {!\g_tmpa_left_bool}
                  }
                }
                % Left Side
                \begin{minipage}[t]{.7\linewidth}
                  \seq_use:Nnnn \g_tmpa_left_seq {\mbox{}\\} {\mbox{}\\} {\mbox{}\\}
                  % \xdef\printSemester {\printSemester}
                  % printSemester: \tl_if_empty:NTF \printSemester {true}{false},
                  % sem: \tl_if_empty:NTF \g_ptxcd_ex_semester_tl {true} {false}
                  % \tl_count:N{\printSemester}
                  \gdef\ptxcd_nextsep{\\}
                \end{minipage}
                \seq_if_empty:NF {\g_tmpa_right_seq}{
                  \begin{minipage}[t]{.3\linewidth}
                    \raggedleft
                    \begin{flushright}
                      % \tl_if_empty:NF \g_ptxcd_ex_semester_tl {\ptxcd_nextsep_right\textbf{\textsf{Semester:~}}\g_ptxcd_ex_semester_tl\def\ptxcd_nextsep_right{\\}}
                      % \tl_if_empty:NF \g_ptxcd_ex_sheetver_tl {\ptxcd_nextsep_right\textbf{\textsf{v\g_ptxcd_ex_sheetver_tl}}\def\ptxcd_nextsep_right{\\}}
                      % \tl_if_empty:NF \g_ptxcd_ex_fachbereich_tl {\ptxcd_nextsep_right\textbf{\textsf{Fachbereich:~}}\g_ptxcd_ex_fachbereich_tl\def\ptxcd_nextsep_right{\\}}
                      \seq_use:Nnnn \g_tmpa_right_seq {\mbox{}\\} {\mbox{}\\} {\mbox{}\\}
                    \end{flushright}
                    \gdef\ptxcd_nextsep{\\}
                  \end{minipage}
                  \tl_if_empty:NF \g_ptxcd_ex_term_tl {\ptxcd_nextsep\g_ptxcd_ex_term_tl}
                }
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

% Better Task Titles
\renewcommand*\sectionlinesformat[4]{%
  \parbox{\linewidth}{
    \bool_if:cT {g__ptxcd_ruled_#1_bool} {
      \rule[5\g_ptxcd_titlerule_dim]{\linewidth}{\g_ptxcd_titlerule_dim}\par\nointerlineskip
    }
    \@hangfrom{%
      \hskip #2#3}{
      \tl_if_eq:nnT {#1} {task} {
        \exp_args:No \tl_if_empty:nF {\bool_if:NTF \g_is_summary_bool {#4} {\textrm{#4}}}% Übungstitel mit Seriefen
        {:~}
        \bool_if:NT \l__ptxcd_points_auto_bool {
          \exp_args:NNx \prop_get:NnN \g__ptxcd_loaded_points_prop {\thetask} \l_ptxcd_tmp_tl
          \quark_if_no_value:NF \l_ptxcd_tmp_tl {
            \fp_set:Nn \l_ptxcd_ex_task_points_fp {\l_ptxcd_tmp_tl}
          }
        }
      }
      {\bool_if:NTF \g_is_summary_bool {#4} {\textrm{#4}}}% Übungstitel mit Seriefen
      \tl_if_in:nnT {#1} {task} {
        \tl_if_empty:cTF{l_ptxcd_ex_#1_credit_tl}
        {\pointformat{\fp_to_decimal:c {l_ptxcd_ex_#1_points_fp}}}
        {\creditformat{\tl_use:c {l_ptxcd_ex_#1_credit_tl}}}
      }
      \rule[-\dp\strutbox]{0pt}{\dp\strutbox}\par}\nointerlineskip
    \skip_vertical:n {\ptxcd_titlerule_sep: -\dp\strutbox}
    \bool_if:cT {g__ptxcd_ruled_#1_bool} {\smash{\rule{\linewidth}{\g_ptxcd_titlerule_dim}}}
  }}

% Custom Headline Style
\clist_map_inline:nn {odd, even, oneside} {
  \keys_define:nn {ptxcd/exercise/headline} {
    #1 .choice:,
    #1 / title-name-id .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
      \g_ptxcd_shorttitle_tl\par
      \StudentName\StudentID},
    #1 / title-name .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
      \g_ptxcd_shorttitle_tl\par
      \smallskip
      \StudentName},
    #1 / title .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {\g_ptxcd_shorttitle_tl},
    #1 / name-id .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {\StudentName\StudentID},
    #1 / name .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {\StudentName},
    #1 / aud .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {
      \textbf{\g_ptxcd_shorttitle_tl}\space{}im\space\textbf{\g_ptxcd_ex_semester_tl}\space{}bei\space\textbf{\g_ptxcd_ex_dozent_tl}\hfill Übungsblatt\space{}\padzeroes[2]{\g_ptxcd_ex_sheetnum_tl}\par
      \StudentName\StudentID},
    #1 / summary-centered .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {%
      \centering\textbf{\sffamily\g_ptxcd_shorttitle_tl\space{}Zusammenfassung}\space{}von\space{}\seq_use:Nnnn \g_ptxcd_author_seq {~\authorandname{}~} {,~} {~\authorandname{}~}},
    #1 / unknown .code:n = \tl_gset:cn {g_ptxcd_ex_headline_#1_tl} {##1}
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

\ExplSyntaxOn

% A Gray Info Box (gray bar on the Left+ light gray background)
\newtcolorbox{grayInfoBox}[1][]{
  colback=\bool_if:NTF \g_dark_mode_bool {fgcolor!10!\thepagecolor } {gray!10!\thepagecolor}, %Hintergrundfarbe
  % colback=fgcolor!10!\thepagecolor, %Hintergrundfarbe
  coltext=.,
  colframe=gray, % Randfarbe
  frame\space hidden,
  title\space style=black!80,
  arc=\boxarc,
  boxrule=0pt,
  left=5pt, % Links Platz lassen
  enhanced, % Erlaubt uns, den ramen zu zeichnen
  fonttitle=\sffamily, % Titelschriftart auf 
  overlay={ % Für Grauen Bereich links
      \begin{tcbclipinterior}
        \fill[gray] (frame.south\space west) rectangle ([xshift=4pt]frame.north\space west); % Zeilennummernbereich färben
      \end{tcbclipinterior}
    },
  #1 % Weitere Argumente zulassen
}
\ExplSyntaxOff

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
  colback=accentcolor!10!\thepagecolor, %Hintergrundfarbe
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

% Minted Line Number Styling
\renewcommand{\theFancyVerbLine}{\tikz{\coordinate(a);\node[text width=5mm,inner sep=0pt,align=center]{\ttfamily\textcolor{white}{\scriptsize\arabic{FancyVerbLine}}};}}

\ExplSyntaxOn

% Environment für meinen Style (Arg 1 = minted Options, Arg 2 = tcolorbox Options)
\newtcblisting{codeBlock}[2][]{
  listing\space engine=minted, % Minted verwenden
  colback=\bool_if:NTF\g_dark_mode_bool {codebg}{fgcolor!10!\thepagecolor}, %Hintergrundfarbe
  colframe=black!70, % Randfarbe
  coltext=.,
  listing\space only,  % Sonst will er den Plain Text nach dem Minted Listing noch anfügen
  frame\space hidden,
  boxrule=0pt,
  arc=\boxarc,
  %hbox, % This option could be used to limit the Length of Code Blocks automatically, but does not work with the minted Line Numbers
  title\space style=\bool_if:NTF\g_dark_mode_bool {accentcolor!40!black} {black!90},
  minted\space style=\bool_if:NTF\g_dark_mode_bool {paraiso-dark} {default}, %Sieht actually worse aus imo
  minted\space language=java, % Sprache setzen
  minted\space options={ %Minted Optionen
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
    \fill[black!70] (frame.south\space west) rectangle ([xshift=5mm]frame.north\space west); % Zeilennummernbereich färben
  \end{tcbclipinterior}
  },
  #2 % Weitere Argumente zulassen
  }
  \ExplSyntaxOff
  
  % --Makros--
  \newenvironment*{cpenumerate}[1][]{\begin{enumerate}[nosep, #1]}{\end{enumerate}}
\newcommand{\code}[1]{\texttt{\footnotesize{}#1}}
\newcommand{\raisedcode}[1]{\raisebox{.1em}{\code{#1}}}
\ExplSyntaxOn
\newcommand{\bluecode}[1]{\code{\textcolor{\bool_if:NTF \g_dark_mode_bool {cyan} {blue}}{#1}}}
\ExplSyntaxOff
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
\newcommand{\rechnung}{\textbf{\textsf{Rechnung: }}}
\newcommand{\fakebullet}{~\raisebox{-.2\height}{\llap{\textbullet}}~}
\newcommand{\fakebullett}{~\llap{-}~}
\newcommand{\fakebullettt}{~\llap{*}~}
\newcommand{\mlcell}[2][l]{\Gape[0pt][2pt]{\makecell[#1]{#2}}}

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
