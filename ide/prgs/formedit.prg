/*
 * $Id: formedit.prg,v 1.32 2014-09-19 23:07:10 fyurisich Exp $
 */
/*
 * ooHG IDE+ form generator
 *
 * Copyright 2002-2014 Ciro Vargas Clemov <cvc@oohg.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software. If not, visit the web site:
 * <http://www.gnu.org/licenses/>
 *
 */

#include "oohg.ch"
#include "hbclass.ch"
#include "i_windefs.ch"

#DEFINE CR CHR(13)
#DEFINE LF CHR(10)
#DEFINE UpperNIL( cValue ) IIF( Upper( AllTrim( cValue ) ) == 'NIL', 'NIL', cValue )

//------------------------------------------------------------------------------
CLASS TFormEditor
//------------------------------------------------------------------------------
   // variables varias
   DATA aLine                INIT {}
   DATA cForm                INIT ''
   DATA CurrentControl       INIT 0
   DATA cvcControls          INIT NIL
   DATA Form_Main            INIT NIL
   DATA FormCtrlOrder        INIT NIL
   DATA lAddingNewControl    INIT .F.
   DATA lFSave               INIT .T.
   DATA FormList             INIT NIL
   DATA lOrdenFD             INIT .F.
   DATA myHandle             INIT 0
   DATA myIde                INIT NIL
   DATA myTbEditor           INIT NIL
   DATA myMMCtrl             INIT NIL
   DATA myCMCtrl             INIT NIL
   DATA myNMCtrl             INIT NIL
   DATA myDMCtrl             INIT {}
   DATA nControlW            INIT 0
   DATA nEditorIndex         INIT 0
   DATA nHandleP             INIT 0           // index of the selected control into :aControls array
   DATA oCtrlList            INIT NIL
   DATA oDesignForm          INIT NIL
   DATA oWaitMsg             INIT NIL
   DATA swCursor             INIT 0
   DATA swTab                INIT .F.

   /*
      Variables de propiedades y eventos.
      Cada vez que se agrega una propiedad o un evento nuevo a un control, se debe agregar una DATA aqu�.
      Esa DATA debe inicializarse en ::IniArray().
   */
   DATA a3State              INIT {}
   DATA aAction              INIT {}
   DATA aAction2             INIT {}
   DATA aAddress             INIT {}
   DATA aAfterColMove        INIT {}
   DATA aAfterColSize        INIT {}
   DATA aAppend              INIT {}
   DATA aAutoPlay            INIT {}
   DATA aBackColor           INIT {}
   DATA aBackground          INIT {}
   DATA aBackgroundColor     INIT {}
   DATA aBeforeAutoFit       INIT {}
   DATA aBeforeColMove       INIT {}
   DATA aBeforeColSize       INIT {}
   DATA aBold                INIT {}
   DATA aBorder              INIT {}
   DATA aBoth                INIT {}
   DATA aBreak               INIT {}
   DATA aBuffer              INIT {}
   DATA aButtons             INIT {}
   DATA aButtonWidth         INIT {}
   DATA aByCell              INIT {}
   DATA aCancel              INIT {}
   DATA aCaption             INIT {}
   DATA aCenter              INIT {}
   DATA aCenterAlign         INIT {}
   DATA aCheckBoxes          INIT {}
   DATA aClientEdge          INIT {}
   DATA aCObj                INIT {}
   DATA aColumnControls      INIT {}
   DATA aColumnInfo          INIT {}
   DATA aControlW            INIT {}
   DATA aCtrlType            INIT {}
   DATA aDate                INIT {}
   DATA aDefaultYear         INIT {}
   DATA aDelayedLoad         INIT {}
   DATA aDelete              INIT {}
   DATA aDeleteMsg           INIT {}
   DATA aDeleteWhen          INIT {}
   DATA aDescend             INIT {}
   DATA aDIBSection          INIT {}
   DATA aDisplayEdit         INIT {}
   DATA aDoubleBuffer        INIT {}
   DATA aDrag                INIT {}
   DATA aDrop                INIT {}
   DATA aDynamicBackColor    INIT {}
   DATA aDynamicCtrls        INIT {}
   DATA aDynamicForeColor    INIT {}
   DATA aDynBlocks           INIT {}
   DATA aEdit                INIT {}
   DATA aEditKeys            INIT {}
   DATA aEditLabels          INIT {}
   DATA aEnabled             INIT {}
   DATA aExclude             INIT {}
   DATA aExtDblClick         INIT {}
   DATA aField               INIT {}
   DATA aFields              INIT {}
   DATA aFile                INIT {}
   DATA aFileType            INIT {}
   DATA aFirstItem           INIT {}
   DATA aFit                 INIT {}
   DATA aFixBlocks           INIT {}
   DATA aFixedCols           INIT {}
   DATA aFixedCtrls          INIT {}
   DATA aFixedWidths         INIT {}
   DATA aFlat                INIT {}
   DATA aFocusedPos          INIT {}
   DATA aFocusRect           INIT {}
   DATA aFontColor           INIT {}
   DATA aFontItalic          INIT {}
   DATA aFontName            INIT {}
   DATA aFontSize            INIT {}
   DATA aFontStrikeout       INIT {}
   DATA aFontUnderline       INIT {}
   DATA aForceRefresh        INIT {}
   DATA aForceScale          INIT {}
   DATA aFull                INIT {}
   DATA aGripperText         INIT {}
   DATA aHandCursor          INIT {}
   DATA aHBitmap             INIT {}
   DATA aHeaderImages        INIT {}
   DATA aHeaders             INIT {}
   DATA aHelpID              INIT {}
   DATA aHotTrack            INIT {}
   DATA aImage               INIT {}
   DATA aImageMargin         INIT {}
   DATA aImagesAlign         INIT {}
   DATA aImageSize           INIT {}
   DATA aImageSource         INIT {}
   DATA aIncrement           INIT {}
   DATA aIncremental         INIT {}
   DATA aIndent              INIT {}
   DATA aInPlace             INIT {}
   DATA aInputMask           INIT {}
   DATA aInsertType          INIT {}
   DATA aIntegralHeight      INIT {}
   DATA aInvisible           INIT {}
   DATA aItemCount           INIT {}
   DATA aItemIDs             INIT {}
   DATA aItemImageNumber     INIT {}
   DATA aItemImages          INIT {}
   DATA aItems               INIT {}
   DATA aItemSource          INIT {}
   DATA aJustify             INIT {}
   DATA aLeft                INIT {}
   DATA aLikeExcel           INIT {}
   DATA aListWidth           INIT {}
   DATA aLock                INIT {}
   DATA aLowerCase           INIT {}
   DATA aMarquee             INIT {}
   DATA aMaxLength           INIT {}
   DATA aMultiLine           INIT {}
   DATA aMultiSelect         INIT {}
   DATA aName                INIT {}
   DATA aNo3DColors          INIT {}
   DATA aNoAutoSizeMovie     INIT {}
   DATA aNoAutoSizeWindow    INIT {}
   DATA aNoClickOnCheck      INIT {}
   DATA aNodeImages          INIT {}
   DATA aNoDelMsg            INIT {}
   DATA aNoErrorDlg          INIT {}
   DATA aNoFocusRect         INIT {}
   DATA aNoHeaders           INIT {}
   DATA aNoHideSel           INIT {}
   DATA aNoHScroll           INIT {}
   DATA aNoLines             INIT {}
   DATA aNoLoadTrans         INIT {}
   DATA aNoMenu              INIT {}
   DATA aNoModalEdit         INIT {}
   DATA aNoOpen              INIT {}
   DATA aNoPlayBar           INIT {}
   DATA aNoPrefix            INIT {}
   DATA aNoRClickOnCheck     INIT {}
   DATA aNoRefresh           INIT {}
   DATA aNoRootButton        INIT {}
   DATA aNoTabStop           INIT {}
   DATA aNoTicks             INIT {}
   DATA aNoToday             INIT {}
   DATA aNoTodayCircle       INIT {}
   DATA aNoVScroll           INIT {}
   DATA aNumber              INIT {}                     // End line of control's definition in .fmg file
   DATA aNumeric             INIT {}
   DATA aOnAbortEdit         INIT {}
   DATA aOnAppend            INIT {}
   DATA aOnChange            INIT {}
   DATA aOnCheckChg          INIT {}
   DATA aOnDblClick          INIT {}
   DATA aOnDelete            INIT {}
   DATA aOnDisplayChange     INIT {}
   DATA aOnDrop              INIT {}
   DATA aOnEditCell          INIT {}
   DATA aOnEnter             INIT {}
   DATA aOnGotFocus          INIT {}
   DATA aOnHeadClick         INIT {}
   DATA aOnHeadRClick        INIT {}
   DATA aOnHScroll           INIT {}
   DATA aOnLabelEdit         INIT {}
   DATA aOnListClose         INIT {}
   DATA aOnListDisplay       INIT {}
   DATA aOnLostFocus         INIT {}
   DATA aOnMouseMove         INIT {}
   DATA aOnQueryData         INIT {}
   DATA aOnRefresh           INIT {}
   DATA aOnSelChange         INIT {}
   DATA aOnTextFilled        INIT {}
   DATA aOnVScroll           INIT {}
   DATA aOpaque              INIT {}
   DATA aPageNames           INIT {}
   DATA aPageObjs            INIT {}
   DATA aPageSubClasses      INIT {}
   DATA aPassWord            INIT {}
   DATA aPicture             INIT {}
   DATA aPlainText           INIT {}
   DATA aPLM                 INIT {}
   DATA aRange               INIT {}
   DATA aReadOnly            INIT {}
   DATA aReadOnlyB           INIT {}
   DATA aRecCount            INIT {}
   DATA aRefresh             INIT {}
   DATA aReplaceField        INIT {}
   DATA aRightAlign          INIT {}
   DATA aRTL                 INIT {}
   DATA aSearchLapse         INIT {}
   DATA aSelBold             INIT {}
   DATA aSelColor            INIT {}
   DATA aShowAll             INIT {}
   DATA aShowMode            INIT {}
   DATA aShowName            INIT {}
   DATA aShowNone            INIT {}
   DATA aShowPosition        INIT {}
   DATA aSingleBuffer        INIT {}
   DATA aSingleExpand        INIT {}
   DATA aSmooth              INIT {}
   DATA aSort                INIT {}
   DATA aSourceOrder         INIT {}
   DATA aSpacing             INIT {}
   DATA aSpeed               INIT {}                     // Start line of control's definition in .fmg file
   DATA aStretch             INIT {}
   DATA aSubClass            INIT {}
   DATA aSync                INIT {}
   DATA aTabPage             INIT {}                     // Each item is { cTabName, nPageCount }
   DATA aTarget              INIT {}
   DATA aTextHeight          INIT {}
   DATA aThemed              INIT {}
   DATA aTitleBackColor      INIT {}
   DATA aTitleFontColor      INIT {}
   DATA aToolTip             INIT {}
   DATA aTop                 INIT {}
   DATA aTrailingFontColor   INIT {}
   DATA aTransparent         INIT {}
   DATA aUnSync              INIT {}
   DATA aUpdate              INIT {}
   DATA aUpdateColors        INIT {}
   DATA aUpDown              INIT {}
   DATA aUpperCase           INIT {}
   DATA aValid               INIT {}
   DATA aValidMess           INIT {}
   DATA aValue               INIT {}
   DATA aValueL              INIT {}
   DATA aValueN              INIT {}
   DATA aValueSource         INIT {}
   DATA aVertical            INIT {}
   DATA aVirtual             INIT {}
   DATA aVisible             INIT {}
   DATA aWeekNumbers         INIT {}
   DATA aWhen                INIT {}
   DATA aWhiteBack           INIT {}
   DATA aWidths              INIT {}
   DATA aWorkArea            INIT {}
   DATA aWrap                INIT {}

   // variables de forms
   DATA cFBackcolor          INIT 'NIL'
   DATA cFBackImage          INIT ""
   DATA cFCursor             INIT ""
   DATA cFDblClickProcedure  INIT ""
   DATA cFFontColor          INIT 'NIL'
   DATA cFFontName           INIT ''
   DATA cFIcon               INIT ""
   DATA cFMClickProcedure    INIT ""
   DATA cFMDblClickProcedure INIT ""
   DATA cFMoveProcedure      INIT ""
   DATA cFName               INIT ""
   DATA cFNotifyIcon         INIT ""
   DATA cFNotifyToolTip      INIT ""
   DATA cFObj                INIT ""
   DATA cFOnMaximize         INIT ""
   DATA cFOnMinimize         INIT ""
   DATA cFontColor           INIT ""
   DATA cFParent             INIT ""
   DATA cFRClickProcedure    INIT ""
   DATA cFRDblClickProcedure INIT ""
   DATA cFRestoreProcedure   INIT ""
   DATA cFSubClass           INIT ""
   DATA cFTitle              INIT ""
   DATA lFBreak              INIT .F.
   DATA lFChild              INIT .F.
   DATA lFClientArea         INIT .F.
   DATA lFFocused            INIT .F.
   DATA lFGripperText        INIT .F.
   DATA lFHelpButton         INIT .F.
   DATA lFInternal           INIT .F.
   DATA lFMain               INIT .F.
   DATA lFMDI                INIT .F.
   DATA lFMDIChild           INIT .F.
   DATA lFMDIClient          INIT .F.
   DATA lFModal              INIT .F.
   DATA lFModalSize          INIT .F.
   DATA lFNoAutoRelease      INIT .F.
   DATA lFNoCaption          INIT .F.
   DATA lFNoMaximize         INIT .F.
   DATA lFNoMinimize         INIT .F.
   DATA lFNoShow             INIT .F.
   DATA lFNoSize             INIT .F.
   DATA lFNoSysmenu          INIT .F.
   DATA lFRTL                INIT .F.
   DATA lFSplitChild         INIT .F.
   DATA lFStretch            INIT .F.
   DATA lFTopmost            INIT .F.
   DATA nFFontSize           INIT 0
   DATA nFMaxHeight          INIT 0
   DATA nFMaxWidth           INIT 0
   DATA nFMinHeight          INIT 0
   DATA nFMinWidth           INIT 0
   DATA nFVirtualH           INIT 0
   DATA nFVirtualW           INIT 0

   // variables de events
   DATA cFOnGotFocus         INIT ""
   DATA cFOnHScrollbox       INIT ""
   DATA cFOnInit             INIT ""
   DATA cFOnInteractiveClose INIT ""
   DATA cFOnLostFocus        INIT ""
   DATA cFOnMouseClick       INIT ""
   DATA cFOnMouseDrag        INIT ""
   DATA cFOnMouseMove        INIT ""
   DATA cFOnNotifyClick      INIT ""
   DATA cFOnPaint            INIT ""
   DATA cFOnRelease          INIT ""
   DATA cFOnScrollDown       INIT ""
   DATA cFOnScrollLeft       INIT ""
   DATA cFOnScrollRight      INIT ""
   DATA cFOnScrollUp         INIT ""
   DATA cFOnSize             INIT ""
   DATA cFOnVScrollbox       INIT ""

   // variables de statusbar
   DATA cSAction             INIT ''
   DATA cSAlign              INIT ''
   DATA cSCAction            INIT ''
   DATA cSCAlign             INIT ''
   DATA cSCaption            INIT ''
   DATA cSCImage             INIT ''
   DATA cSCObj               INIT ''
   DATA cSCStyle             INIT ''
   DATA cSCToolTip           INIT ''
   DATA cSDAction            INIT ''
   DATA cSDAlign             INIT ''
   DATA cSDStyle             INIT ''
   DATA cSDToolTip           INIT ''
   DATA cSFontName           INIT ''
   DATA cSIcon               INIT ''
   DATA cSKAction            INIT ''
   DATA cSKAlign             INIT ''
   DATA cSKImage             INIT ''
   DATA cSKStyle             INIT ''
   DATA cSKToolTip           INIT ''
   DATA cSStyle              INIT ''
   DATA cSSubClass           INIT ''
   DATA cSToolTip            INIT ''
   DATA cSWidth              INIT ''
   DATA lSBold               INIT .F.
   DATA lSCAmPm              INIT .F.
   DATA lSDate               INIT .F.
   DATA lSItalic             INIT .F.
   DATA lSKeyboard           INIT .F.
   DATA lSNoAutoAdjust       INIT .F.
   DATA lSStat               INIT .F.
   DATA lSStrikeout          INIT .F.
   DATA lSTime               INIT .F.
   DATA lSTop                INIT .F.
   DATA lSUnderline          INIT .F.
   DATA nSCWidth             INIT 0
   DATA nSDWidth             INIT 0
   DATA nSFontSize           INIT 0
   DATA nSKWidth             INIT 0

   // variables de contadores de tipos de controles
   DATA ControlPrefix        INIT { 'form_', 'button_', 'checkbox_', 'list_', 'combo_', 'checkbtn_', 'grid_', 'frame_', 'tab_', 'image_', 'animate_', 'datepicker_', 'text_', 'edit_', 'label_', 'player_', 'progressbar_', 'radiogroup_', 'slider_', 'spinner_', 'piccheckbutt_', 'picbutt_', 'timer_', 'browse_', 'tree_', 'ipaddress_', 'monthcal_',     'hyperlink_', 'richeditbox_', 'timepicker_', 'xbrowse_' }
   DATA ControlType          INIT { 'FORM',  'BUTTON',  'CHECKBOX',  'LIST',  'COMBO',  'CHECKBTN',  'GRID',  'FRAME',  'TAB',  'IMAGE',  'ANIMATE',  'DATEPICKER',  'TEXT',  'EDIT',  'LABEL',  'PLAYER',  'PROGRESSBAR',  'RADIOGROUP',  'SLIDER',  'SPINNER',  'PICCHECKBUTT',  'PICBUTT',  'TIMER',  'BROWSE',  'TREE',  'IPADDRESS',  'MONTHCALENDAR', 'HYPERLINK',  'RICHEDIT',     'TIMEPICKER',  'XBROWSE' }
   DATA ControlCount         INIT { 0,       0,         0,           0,       0,        0,           0,       0,        0,      0,        0,          0,             0,       0,       0,        0,         0,              0,             0,         0,          0,               0,          0,        0,         0,       0,            0,               0,            0,              0,             0 }

   METHOD AddControl
   METHOD AddCtrlToTabPage
   METHOD AddTabPage
   METHOD CheckIfIsFrame
   METHOD Clean
   METHOD Control_Click
   METHOD CopyControl
   METHOD Cordenada
   METHOD CreateControl
   METHOD CreateStatusBar
   METHOD CtrlFontColors
   METHOD Debug
   METHOD DeleteControl
   METHOD DeleteTabPage
   METHOD Dibuja
   METHOD Edit_Properties
   METHOD EditForm           CONSTRUCTOR
   METHOD Events_Click
   METHOD Exit
   METHOD FillControl
   METHOD FilterDC
   METHOD FrmEvents
   METHOD FrmFontColors
   METHOD FrmProperties
   METHOD GlobalVertGapChg
   METHOD GOtherColors
   METHOD IniArray
   METHOD KMove
   METHOD KMueve
   METHOD LeaCol
   METHOD LeaColF
   METHOD LeaDato
   METHOD LeaDato_Oop
   METHOD LeaDatoLogic
   METHOD LeaDatoStatus
   METHOD LeaRow
   METHOD LeaRowF
   METHOD LeaTipo
   METHOD LlenaCon
   METHOD LlenaTipos
   METHOD MakeControls
   METHOD ManualMoSI
   METHOD MinimizeForms
   METHOD MisPuntos
   METHOD MouseMoveSize
   METHOD MoveControl
   METHOD New
   METHOD Open
   METHOD Ord_Abajo
   METHOD Ord_Arriba
   METHOD OrderControl
   METHOD pAnimateBox
   METHOD pBrowse
   METHOD pButton
   METHOD pCheckBox
   METHOD pCheckBtn
   METHOD pComboBox
   METHOD pDatePicker
   METHOD pEditBox
   METHOD pForm
   METHOD pFrame
   METHOD pGrid
   METHOD pHypLink
   METHOD pImage
   METHOD pIPAddress
   METHOD pLabel
   METHOD pListBox
   METHOD pMonthCal
   METHOD pPicButt
   METHOD pPicCheckButt
   METHOD pPlayer
   METHOD pProgressBar
   METHOD pRadioGroup
   METHOD pRichedit
   METHOD PrintBrief
   METHOD ProcesaControl
   METHOD ProcessContainers
   METHOD Properties_Click
   METHOD pSlider
   METHOD pSpinner
   METHOD pTab
   METHOD pTextBox
   METHOD pTimePicker
   METHOD pTimer
   METHOD pTree
   METHOD pXBrowse
   METHOD RefreshControlInspector
   METHOD RestoreForms
   METHOD Save
   METHOD SelectControl
   METHOD SetBackColor
   METHOD SetDefaultBackColor
   METHOD SetFontType
   METHOD ShowFormData
   METHOD SiEsDEste
   METHOD SizeControl
   METHOD Snap
   METHOD StatPropEvents
   METHOD Swapea
   METHOD TabEvents
   METHOD TabProperties
   METHOD ValCellPos
   METHOD VerifyBar
   METHOD ValGlobalPos
ENDCLASS

//------------------------------------------------------------------------------
METHOD EditForm( myIde, cFullName, nEditorIndex, lWait ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nPos, cName

   CursorWait()

   SET INTERACTIVECLOSE OFF

   ::myIde        := myIde
   ::nEditorIndex := nEditorIndex
   ::cFFontColor  := ::myIde:cFormDefFontColor
   ::cFFontName   := ::myIde:cFormDefFontName
   ::nFFontSize   := ::myIde:nFormDefFontSize
   ::myTbEditor   := TMyToolBarEditor():New( Self )


   DEFINE WINDOW 0 OBJ ::oWaitMsg ;
      AT 10, 10 ;
      WIDTH 150 ;
      HEIGHT 100 ;
      TITLE "Information" ;
      CHILD ;
      NOSHOW ;
      NOSYSMENU ;
      NOCAPTION ;
      BACKCOLOR ::myIde:aSystemColor ;
      ON INIT ::oWaitMsg:Center()

      @ 35, 15 LABEL label_1 ;
         VALUE 'Please wait ...' ;
         AUTOSIZE ;
         FONT 'Times new Roman' ;
         SIZE 14
   END WINDOW

   DEFINE WINDOW 0 OBJ ::Form_Main ;
      AT 0,0 ;
      WIDTH 689 ;
      HEIGHT 104 ;
      TITLE 'ooHG IDE Plus - Form designer' ;
      CHILD ;
      NOSHOW ;
      NOMAXIMIZE ;
      NOSIZE ;
      ICON "Edit" ;
      FONT 'MS Sans Serif' ;
      SIZE 10 ;
      BACKCOLOR ::myIde:aSystemColor ;
      ON MINIMIZE ::MinimizeForms() ;
      ON MAXIMIZE ::RestoreForms() ;
      ON RESTORE ::RestoreForms()

      @ 17,10 BUTTON exit ;
         PICTURE 'A1';
         ACTION ::Exit() ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Exit'

      @ 17,41 BUTTON save ;
         PICTURE 'A2';
         ACTION ::Save( 0 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Save'

      @ 17,73 BUTTON save_as ;
         PICTURE 'A3';
         ACTION ::Save( 1 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Save as'

      @ 17,112 BUTTON form_prop ;
         PICTURE 'A4';
         ACTION ::FrmProperties() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Properties'

      @ 17,144 BUTTON events_prop ;
         PICTURE 'A5';
         ACTION ::FrmEvents() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Events'

      @ 17,176 BUTTON form_mc ;
         PICTURE 'A6';
         ACTION ::FrmFontColors() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Fonts and Colors'

      @ 17,209 BUTTON tbc_fmms ;
         PICTURE 'A7';
         ACTION ::ManualMoSi( 0 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Manual Move/Size'

      @ 17,240 BUTTON mmenu1 ;
         PICTURE 'A8';
         ACTION TMyMenuEditor():Edit( Self, 1 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Main Menu'

      @ 17,273 BUTTON mmenu2 ;
         PICTURE 'A9';
         ACTION TMyMenuEditor():Edit( Self, 2 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Context Menu'

      @ 17,303 BUTTON mmenu3 ;
         PICTURE 'A10';
         ACTION TMyMenuEditor():Edit( Self, 3 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Notify Menu'

      @ 17,337 BUTTON toolb ;
         PICTURE 'A11';
         ACTION ::myTbEditor:Edit() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Toolbar'

      @ 17,368 BUTTON form_co ;
         PICTURE 'A12';
         ACTION ::OrderControl() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Order'

      @ 17,400 BUTTON  butt_status ;
         PICTURE 'A13';
         ACTION ::VerifyBar() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Statusbar On/Off'

      @ 17,444 BUTTON tbc_prop ;
         PICTURE 'A4';
         ACTION ::Properties_Click() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Properties'

      @ 17,477 BUTTON tbc_events ;
         PICTURE 'A5';
         ACTION ::Events_Click() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Events'

      @ 17,510 BUTTON tbc_ifc ;
         PICTURE 'A6';
         ACTION ::CtrlFontColors() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Font Color'

      @ 17,540 BUTTON tbc_mms ;
         PICTURE 'A7';
         ACTION ::ManualMoSI( 1 ) ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Manual Move/Size'

      @ 17,572 BUTTON tbc_im ;
         PICTURE 'A17';
         ACTION ::MoveControl() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Interactive Move'

      @ 17,604 BUTTON tbc_is ;
         PICTURE 'A14';
         ACTION ::SizeControl() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Interactive Size'

      @ 17,634 BUTTON tbc_del ;
         PICTURE 'A16';
         ACTION ::DeleteControl() ;
         WIDTH 30 ;
         HEIGHT 28 ;
         TOOLTIP 'Delete'

      @ 0,105 FRAME frame_1 ;
         CAPTION "Form : " + cFullName ;
         WIDTH 332 ;
         HEIGHT 65 ;
         SIZE 9

      @ 0,436 FRAME frame_2 ;
         CAPTION "Control : " ;
         WIDTH 236 ;
         HEIGHT 65 ;
         OPAQUE ;
         SIZE 9

      @ 0,4 FRAME frame_3 ;
         CAPTION "Action" ;
         WIDTH 105 ;
         HEIGHT 65 ;
         SIZE 9

      @ 48,115 LABEL label_1 ;
         WIDTH 120 ;
         HEIGHT 24 ;
         VALUE '' ;
         SIZE 9 ;
         AUTOSIZE

      @ 48,446 LABEL label_2 ;
         WIDTH 120 ;
         HEIGHT 24 ;
         VALUE 'r:    c:    w:    h: ' ;
         SIZE 9 ;
         AUTOSIZE

      @ 48,300 LABEL labelyx ;
         WIDTH 98 ;
         HEIGHT 24 ;
         VALUE '0000,0000' ;
         SIZE 9 ;
         AUTOSIZE

   END WINDOW

   DEFINE WINDOW 0 OBJ ::cvcControls ;
      AT ::myIde:MainHeight + 46, 0 ;
      WIDTH 65 ;
      HEIGHT 480 + GetTitleHeight() + GetBorderheight() ;
      TITLE 'Controls' ;
      ICON 'VD' ;
      CHILD ;
      NOSHOW ;
      NOSIZE ;
      NOMAXIMIZE ;
      NOAUTORELEASE ;
      NOMINIMIZE ;
      NOSYSMENU ;
      BACKCOLOR ::myIde:aSystemColor

      @ 001, 00 CHECKBUTTON Control_01 ;
         PICTURE 'SELECT' ;
         VALUE .T. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Select Object' ;
         ON CHANGE ::Control_Click( 1 )

      @ 001, 29 CHECKBUTTON Control_02 ;
         PICTURE 'BUTTON1' ;                     // Cambio en .RC
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Button and ButtonMixed' ;
         ON CHANGE ::Control_Click( 2 )

      @ 030, 00 CHECKBUTTON Control_03 ;
         PICTURE 'CHECKBOX1' ;                     // Cambio en .RC
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'CheckBox' ;
         ON CHANGE ::Control_Click( 3 )

      @ 030, 29 CHECKBUTTON Control_04 ;
         PICTURE 'LISTBOX1' ;                     // Cambio en .RC
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'ListBox' ;
         ON CHANGE ::Control_Click( 4 )

      @ 060, 00 CHECKBUTTON Control_05 ;
         PICTURE 'COMBOBOX1' ;                     // Cambio en .RC
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'ComboBox' ;
         ON CHANGE ::Control_Click( 5 )

      @ 060, 29 CHECKBUTTON Control_06 ;
         PICTURE 'CHECKBUTTON' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'CheckButton' ;
         ON CHANGE ::Control_Click( 6 )

      @ 090, 00 CHECKBUTTON Control_07 ;
         PICTURE 'GRID' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Grid' ;
         ON CHANGE ::Control_Click( 7 )

      @ 090, 29 CHECKBUTTON Control_08 ;
         PICTURE 'FRAME' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Frame' ;
         ON CHANGE ::Control_Click( 8 )

      @ 120, 00 CHECKBUTTON Control_09 ;
         PICTURE 'TAB' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Tab' ;
         ON CHANGE ::Control_Click( 9 )

      @ 120, 29 CHECKBUTTON Control_10 ;
         PICTURE 'IMAGE' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Image' ;
         ON CHANGE ::Control_Click( 10 )

      @ 150, 00 CHECKBUTTON Control_11 ;
         PICTURE 'ANIMATEBOX' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'AnimateBox' ;
         ON CHANGE ::Control_Click( 11 )

      @ 150, 29 CHECKBUTTON Control_12 ;
         PICTURE 'DATEPICKER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'DatePicker' ;
         ON CHANGE ::Control_Click( 12 )

      @ 180, 00 CHECKBUTTON Control_13 ;
         PICTURE 'TEXTBOX' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'TextBox' ;
         ON CHANGE ::Control_Click( 13 )

      @ 180, 29 CHECKBUTTON Control_14 ;
         PICTURE 'EDITBOX' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'EditBox' ;
         ON CHANGE ::Control_Click( 14 )

      @ 210, 00 CHECKBUTTON Control_15 ;
         PICTURE 'LABEL' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Label' ;
         ON CHANGE ::Control_Click( 15 )

      @ 210, 29 CHECKBUTTON Control_16 ;
         PICTURE 'PLAYER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Player' ;
         ON CHANGE ::Control_Click( 16 )

      @ 240, 00 CHECKBUTTON Control_17 ;
         PICTURE 'PROGRESSBAR' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'ProgressBar' ;
         ON CHANGE ::Control_Click( 17 )

      @ 240, 29 CHECKBUTTON Control_18 ;
         PICTURE 'RADIOGROUP' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'RadioGroup' ;
         ON CHANGE ::Control_Click( 18 )

      @ 270, 00 CHECKBUTTON Control_19 ;
         PICTURE 'SLIDER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Slider' ;
         ON CHANGE ::Control_Click( 19 )

      @ 270, 29 CHECKBUTTON Control_20 ;
         PICTURE 'SPINNER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Spinner' ;
         ON CHANGE ::Control_Click( 20 )

      @ 300, 00 CHECKBUTTON Control_21 ;
         PICTURE 'IMAGECHECKBUTTON' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Picture CheckButton' ;
         ON CHANGE ::Control_Click( 21 )

      @ 300, 29 CHECKBUTTON Control_22 ;
         PICTURE 'IMAGEBUTTON' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Picture Button' ;
         ON CHANGE ::Control_Click( 22 )

      @ 330, 00 CHECKBUTTON Control_23 ;
         PICTURE 'TIMER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Timer' ;
         ON CHANGE ::Control_Click( 23 )

      @ 330, 29 CHECKBUTTON Control_24 ;
         PICTURE 'GRID' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Browse' ;
         ON CHANGE ::Control_Click( 24 )

      @ 360, 00 CHECKBUTTON Control_25 ;
         PICTURE 'TREE' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Tree' ;
         ON CHANGE ::Control_Click( 25 )

      @ 360, 29 CHECKBUTTON Control_26 ;
         PICTURE 'IPAD' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'IPAddress' ;
         ON CHANGE ::Control_Click( 26 )

      @ 390, 00 CHECKBUTTON Control_27 ;
         PICTURE 'MONTHCAL' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Monthcalendar' ;
         ON CHANGE ::Control_Click( 27 )

      @ 390, 29 CHECKBUTTON Control_28 ;
         PICTURE 'HYPLINK' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Hyperlink' ;
         ON CHANGE ::Control_Click( 28 )

      @ 420, 00 CHECKBUTTON Control_29 ;
         PICTURE 'RICHEDIT' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Richeditbox' ;
         ON CHANGE ::Control_Click( 29 )

      @ 420, 29 CHECKBUTTON Control_30 ;
         PICTURE 'TIMER' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'Timepicker' ;
         ON CHANGE ::Control_Click( 30 )

      @ 450, 00 CHECKBUTTON Control_31 ;
         PICTURE 'GRID' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'XBrowse' ;
         ON CHANGE ::Control_Click( 31 )

      @ 450, 29 CHECKBUTTON Control_Stabusbar ;
         PICTURE 'stat' ;
         VALUE .F. ;
         WIDTH 28 ;
         HEIGHT 28 ;
         TOOLTIP 'StatusBar' ;
         ON CHANGE ::StatPropEvents() ;
         INVISIBLE

   END WINDOW

   ::Form_Main:Activate( .T. )
   ::cvcControls:Activate( .T. )
   ::oWaitMsg:Activate( .T. )

// TODO: hide cvccontrols and ::Form_Main when Form is not focused

   ::cForm := cFullName
   nPos := RAt( '\', cFullName )
   cName := SubStr( cFullName, nPos + 1 )
   nPos := RAt( ".", cName )
   IF nPos > 0
      cName := SubStr( cName, 1, nPos - 1 )
   ENDIF
   ::cFName := Lower( cName )

   ::lSStat := .F.
   IF File( cFullName )
      ::Open( cFullName, lWait )
   ELSE
      ::New( lWait )
   ENDIF
RETURN Self

//------------------------------------------------------------------------------
METHOD Open( cFMG, lWait )  CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, j, nContLin, cForma, nStart, nEnd, nFWidth, nFHeight, cName, aColor

   ::oWaitMsg:label_1:Value := 'Loading form ...'
   ::oWaitMsg:Show()

   DEFINE WINDOW 0 OBJ ::FormList ;
      AT ::myIde:MainHeight + 46, ( GetDeskTopWidth() - 380 ) ;
      WIDTH 370 ;
      HEIGHT 490 ;
      CLIENTAREA ;
      TITLE 'Control Inspector' ;
      ICON 'Edit' ;
      CHILD ;
      NOSHOW ;
      NOMAXIMIZE ;
      NOMINIMIZE ;
      NOSIZE ;
      NOSYSMENU ;
      BACKCOLOR ::myIde:aSystemColor ;
      ON INIT SetHeightForWholeRows( ::oCtrlList, 400 )

      @ 10, 10 GRID 0 OBJ ::oCtrlList ;
         WIDTH 350 ;
         HEIGHT 400 ;
         HEADERS { 'Name', 'Row', 'Col', 'Width', 'Height', 'int-name', 'Type' } ;
         WIDTHS { 80, 40, 40, 45, 50, 0, 70 } ;
         FONT "Arial" ;
         SIZE 10 ;
         INPLACE EDIT ;
         READONLY { .T., .F., .F., .F., .F., .T., .T. } ;
         JUSTIFY { GRID_JTFY_LEFT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_LEFT, GRID_JTFY_LEFT } ;
         ON HEADCLICK { {|| ::oCtrlList:SortColumn( 1, .F. ) }, {|| ::oCtrlList:SortColumn( 2, .F. ) }, {|| ::oCtrlList:SortColumn( 3, .F. ) }, {|| ::oCtrlList:SortColumn( 4, .F. ) }, {|| ::oCtrlList:SortColumn( 5, .F. ) }, NIL, {|| ::oCtrlList:SortColumn( 7, .F. ) } } ;
         FULLMOVE ;
         MULTISELECT ;
         ON EDITCELL ::ValCellPos() ;
         ON CHANGE ::SelectControl()
      ::oCtrlList:ColumnHide( 6 )

      DEFINE CONTEXT MENU CONTROL ( ::oCtrlList:Name ) OF ( ::FormList:Name )
         ITEM 'Properties'             ACTION { |aParams| ::Edit_Properties( aParams ) }
         ITEM 'Events    '             ACTION ::Events_Click()
         ITEM 'Font/Colors'            ACTION ::CtrlFontColors()
         ITEM 'Manual Move/Size'       ACTION ::ManualMoSI( 1 )
         ITEM 'Interactive Move'       ACTION ::MoveControl()
         ITEM 'Keyboard Move'          ACTION ::KMove()
         ITEM 'Interactive Size'       ACTION ::SizeControl()
         SEPARATOR
         ITEM 'Global Row Align'       ACTION ::ValGlobalPos( 'ROW' )
         ITEM 'Global Col Align'       ACTION ::ValGlobalPos( 'COL' )
         ITEM 'Global Width Change'    ACTION ::ValGlobalPos( 'WID' )
         ITEM 'Global Height Change'   ACTION ::ValGlobalPos( 'HEI' )
         ITEM 'Global Vert Gap Change' ACTION ::GlobalVertGapChg()
         ITEM 'Global Hor/Ver Shift'   ACTION ::ValGlobalPos( 'SHI' )
         SEPARATOR
         ITEM 'Delete'                 ACTION ::DeleteControl()
         SEPARATOR
         ITEM 'Print Brief'            ACTION ::PrintBrief()
         SEPARATOR
         ITEM "Form's context menu"    ACTION IIF( HB_IsObject( ::myCMCtrl ), ::myCMCtrl:Activate(), MsgInfo( "Context menu is not defined !!!", 'OOHG IDE+' ) )
         ITEM "Form' notify menu"      ACTION IIF( HB_IsObject( ::myNMCtrl ), ::myNMCtrl:Activate(), MsgInfo( "Notify menu is not defined !!!", 'OOHG IDE+' ) )
      END MENU

      @ 420, 10 LABEL lop1 VALUE "Double click or Enter to modify the position or size of a control." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 435, 10 LABEL lop2 VALUE "Right click to access properties or events, or to do global" FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 450, 10 LABEL lop3 VALUE "align/resize of selected controls (use Ctrl+Click to select)." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 465, 10 LABEL lop4 VALUE "Click on the headers to change display order." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
   END WINDOW

   cForma := MemoRead( cFMG )
   nContLin := MLCount( cForma )

   FOR i := 1 TO nContLin
      aAdd( ::aLine, ' ' + MemoLine( cForma, 800, i ) )
      IF ::aLine[i] # NIL
         IF At( "DEFINE WINDOW", ::aLine[i] ) # 0 .OR. ( At( "@ ", ::aLine[i] ) > 0 .AND. At( ",", ::aLine[i] ) > 0 )
            ::nControlW ++
            IF At( "WINDOW", ::aLine[i] ) > 0
               // Form, after WINDOW should come TEMPLATE, but everything is accepted and ignored
               nEnd := Len( ::aLine[i] )
            ELSE
               // Control, skip nCol
               nStart := At( ',', ::aLine[i] ) + 1
               FOR j := nStart TO Len( ::aLine[i] )
                  // Stop at the first letter
                  IF Asc( SubStr( ::aLine[i], j, 1 ) ) >= 65
                     EXIT
                  ENDIF
               NEXT j
               // Skip control type
               nStart := j
               FOR j := nStart TO Len( ::aLine[i] )
                  // Stop at the first space
                  IF SubStr( ::aLine[i], j, 1) == " "
                     EXIT
                  ENDIF
               NEXT j
               nEnd := j
            ENDIF
            // Get name
            cName := SubStr( ::aLine[i], nEnd + 1 )
            cName := StrTran( cName, ";", "" )
            cName := StrTran( cName, chr(10), "" )
            cName := StrTran( cName, chr(13), "" )
            cName := StrTran( cName, " ", "" )
            ::IniArray( ::nControlW, cName, '' )
            ::aSpeed[::nControlW] := i
         ENDIF
      ELSE
         EXIT
      ENDIF
   NEXT i

   FOR i := 1 TO ( ::nControlW - 1 )
       ::aNumber[i] := ::aSpeed[i + 1] - 1
   NEXT i
   ::aNumber[::nControlW] := nContLin

   // Do not force a font when form has none, use OOHG default
   ::cFFontName  := ::Clean( ::LeaDato( 'WINDOW', 'FONT', '' ) )
   ::nFFontSize  := Val( ::LeaDato( 'WINDOW', 'SIZE', '0' ) )
   ::cFBackcolor := UpperNIL( ::LeaDato( 'WINDOW', 'BACKCOLOR', 'NIL' ) )
   nFWidth       := Val( ::LeaDato( 'WINDOW', 'WIDTH', '640' ) )
   nFHeight      := Val( ::LeaDato( 'WINDOW', 'HEIGHT', '480' ) )
   ::nFVirtualW  := Val( ::LeaDato( 'WINDOW', 'VIRTUAL WIDTH', '0' ) )
   ::nFVirtualH  := Val( ::LeaDato( 'WINDOW', 'VIRTUAL HEIGHT', '0' ) )

   cName := _OOHG_GetNullName( "0" )
   aColor := IIF( IsValidArray( ::cFBackcolor ), &( ::cFBackcolor ), NIL )

   DEFINE WINDOW ( cName ) OBJ ::oDesignForm ;
      AT ::myIde:MainHeight + 46, 66 ;
      WIDTH nFWidth ;
      HEIGHT nFHeight ;
      TITLE 'Title' ;
      ICON 'VD' ;
      CHILD ;
      NOSHOW ;
      ON MOUSECLICK ::AddControl() ;
      ON DBLCLICK ::Properties_Click() ;
      ON MOUSEMOVE ::Cordenada() ;
      ON MOUSEDRAG ::MouseMoveSize() ;
      ON GOTFOCUS ::MisPuntos() ;
      ON PAINT ::ShowFormData() ;
      ON SIZE ::MisPuntos() ;
      BACKCOLOR aColor ;
      FONT ::cFFontName ;
      SIZE ::nFFontSize ;
      FONTCOLOR &( ::cFFontColor ) ;
      NOMAXIMIZE ;
      NOMINIMIZE

      DEFINE CONTEXT MENU
         ITEM 'Properties'             ACTION ::Properties_Click()
         ITEM 'Events    '             ACTION ::Events_Click()
         ITEM 'Font/Colors'            ACTION ::CtrlFontColors()
         ITEM 'Manual Move/Size'       ACTION ::ManualMoSI( 1 )
         ITEM 'Interactive Move'       ACTION ::MoveControl()
         ITEM 'Keyboard Move'          ACTION ::KMove()
         ITEM 'Interactive Size'       ACTION ::SizeControl()
         SEPARATOR
         ITEM 'Global Row Align'       ACTION ::ValGlobalPos( 'ROW' )
         ITEM 'Global Col Align'       ACTION ::ValGlobalPos( 'COL' )
         ITEM 'Global Width Change'    ACTION ::ValGlobalPos( 'WID' )
         ITEM 'Global Height Change'   ACTION ::ValGlobalPos( 'HEI' )
         ITEM 'Global Vert Gap Change' ACTION ::GlobalVertGapChg()
         ITEM 'Global Hor/Ver Shift'   ACTION ::ValGlobalPos( 'SHI' )
         SEPARATOR
         ITEM 'Delete'                 ACTION ::DeleteControl()
         SEPARATOR
         ITEM 'Print Brief'            ACTION ::PrintBrief()
         SEPARATOR
         ITEM "Form's context menu"    ACTION IIF( HB_IsObject( ::myCMCtrl ), ::myCMCtrl:Activate(), MsgInfo( "Context menu is not defined !!!", 'OOHG IDE+' ) )
         ITEM "Form' notify menu"      ACTION IIF( HB_IsObject( ::myNMCtrl ), ::myNMCtrl:Activate(), MsgInfo( "Notify menu is not defined !!!", 'OOHG IDE+' ) )
      END MENU

      ON KEY ALT+D  ACTION ::Debug()
      ON KEY DELETE ACTION ::DeleteControl()
      ON KEY F1     ACTION Help_F1( 'FORMEDIT', ::myIde )
   END WINDOW

   ::FillControl()
   ::RefreshControlInspector()

   ::oWaitMsg:Hide()
   CursorArrow()

   ::Form_Main:Show()
   ::cvcControls:Show()
   ::FormList:Show()
   ::oDesignForm:Show()
   ::FormList:Activate( .T. )
   ::oDesignForm:Activate( ! lWait )
RETURN NIL

//------------------------------------------------------------------------------
METHOD New( lWait ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName

   ::oWaitMsg:label_1:Value := 'Creating form ...'
   ::oWaitMsg:Show()

   cName := _OOHG_GetNullName( "0" )

   DEFINE WINDOW ( cName ) OBJ ::oDesignForm ;
      AT ::myIde:MainHeight + 46, 66 ;
      WIDTH 700 ;
      HEIGHT 410 ;
      ICON 'VD' ;
      CHILD ;
      NOSHOW ;
      ON MOUSECLICK ::AddControl() ;
      ON DBLCLICK ::Properties_Click() ;
      ON MOUSEMOVE ::Cordenada() ;
      ON MOUSEDRAG ::MouseMoveSize() ;
      ON GOTFOCUS ::MisPuntos() ;
      ON PAINT ::ShowFormData() ;
      FONT ::cFFontName ;
      SIZE ::nFFontSize ;
      FONTCOLOR &( ::cFFontColor ) ;
      NOMAXIMIZE ;
      NOMINIMIZE

      DEFINE CONTEXT MENU
         ITEM 'Properties'             ACTION ::Properties_Click()
         ITEM 'Events    '             ACTION ::Events_Click()
         ITEM 'Font/Colors'            ACTION ::CtrlFontColors()
         ITEM 'Manual Move/Size'       ACTION ::ManualMoSI( 1 )
         ITEM 'Interactive Move'       ACTION ::MoveControl()
         ITEM 'Keyboard Move'          ACTION ::KMove()
         ITEM 'Interactive Size'       ACTION ::SizeControl()
         SEPARATOR
         ITEM 'Global Row Align'       ACTION ::ValGlobalPos( 'ROW' )
         ITEM 'Global Col Align'       ACTION ::ValGlobalPos( 'COL' )
         ITEM 'Global Width Change'    ACTION ::ValGlobalPos( 'WID' )
         ITEM 'Global Height Change'   ACTION ::ValGlobalPos( 'HEI' )
         ITEM 'Global Vert Gap Change' ACTION ::GlobalVertGapChg()
         ITEM 'Global Hor/Ver Shift'   ACTION ::ValGlobalPos( 'SHI' )
         SEPARATOR
         ITEM 'Delete'                 ACTION ::DeleteControl()
         SEPARATOR
         ITEM 'Print Brief'            ACTION ::PrintBrief()
         SEPARATOR
         ITEM "Form's context menu"    ACTION IIF( HB_IsObject( ::myCMCtrl ), ::myCMCtrl:Activate(), MsgInfo( "Context menu is not defined !!!", 'OOHG IDE+' ) )
         ITEM "Form' notify menu"      ACTION IIF( HB_IsObject( ::myNMCtrl ), ::myNMCtrl:Activate(), MsgInfo( "Notify menu is not defined !!!", 'OOHG IDE+' ) )
      END MENU

      ON KEY DELETE ACTION ::DeleteControl()
      ON KEY F1     ACTION Help_F1( 'FORMEDIT', ::myIde )
      ON KEY ALT+D  ACTION ::Debug()
   END WINDOW

   DEFINE WINDOW 0 OBJ ::FormList ;
      AT ::myIde:MainHeight + 46, ( GetDeskTopWidth() - 380 ) ;
      WIDTH 370 ;
      HEIGHT 490 ;
      CLIENTAREA ;
      TITLE 'Control Inspector' ;
      ICON 'Edit' ;
      CHILD ;
      NOSHOW ;
      NOMAXIMIZE ;
      NOMINIMIZE ;
      NOSIZE ;
      NOSYSMENU ;
      BACKCOLOR ::myIde:aSystemColor ;
      ON INIT SetHeightForWholeRows( ::oCtrlList, 400 )

      @ 10, 10 GRID 0 OBJ ::oCtrlList ;
         WIDTH 350 ;
         HEIGHT 400 ;
         HEADERS { 'Name', 'Row', 'Col', 'Width', 'Height', 'int-name', 'Type' } ;
         WIDTHS { 80, 40, 40, 45, 50, 0, 70 } ;
         FONT "Arial" ;
         SIZE 10 ;
         INPLACE EDIT ;
         READONLY { .T., .F., .F., .F., .F., .T., .T. } ;
         JUSTIFY { GRID_JTFY_LEFT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_RIGHT, GRID_JTFY_LEFT, GRID_JTFY_LEFT } ;
         ON HEADCLICK { {|| ::oCtrlList:SortColumn( 1, .F. ) }, {|| ::oCtrlList:SortColumn( 2, .F. ) }, {|| ::oCtrlList:SortColumn( 3, .F. ) }, {|| ::oCtrlList:SortColumn( 4, .F. ) }, {|| ::oCtrlList:SortColumn( 5, .F. ) }, NIL, {|| ::oCtrlList:SortColumn( 7, .F. ) } } ;
         FULLMOVE ;
         MULTISELECT ;
         ON EDITCELL ::ValCellPos() ;
         ON CHANGE ::SelectControl()
      ::oCtrlList:ColumnHide( 6 )

      DEFINE CONTEXT MENU CONTROL ( ::oCtrlList:Name ) OF ( ::FormList:Name )
         ITEM 'Properties'             ACTION { |aParams| ::Edit_Properties( aParams ) }
         ITEM 'Events    '             ACTION ::Events_Click()
         ITEM 'Font/Colors'            ACTION ::CtrlFontColors()
         ITEM 'Manual Move/Size'       ACTION ::ManualMoSI( 1 )
         ITEM 'Interactive Move'       ACTION ::MoveControl()
         ITEM 'Keyboard Move'          ACTION ::KMove()
         ITEM 'Interactive Size'       ACTION ::SizeControl()
         SEPARATOR
         ITEM 'Global Row Align'       ACTION ::ValGlobalPos( 'ROW' )
         ITEM 'Global Col Align'       ACTION ::ValGlobalPos( 'COL' )
         ITEM 'Global Width Change'    ACTION ::ValGlobalPos( 'WID' )
         ITEM 'Global Height Change'   ACTION ::ValGlobalPos( 'HEI' )
         ITEM 'Global Vert Gap Change' ACTION ::GlobalVertGapChg()
         ITEM 'Global Hor/Ver Shift'   ACTION ::ValGlobalPos( 'SHI' )
         SEPARATOR
         ITEM 'Delete'                 ACTION ::DeleteControl()
         SEPARATOR
         ITEM 'Print Brief'            ACTION ::PrintBrief()
         SEPARATOR
         ITEM "Form's context menu"    ACTION IIF( HB_IsObject( ::myCMCtrl ), ::myCMCtrl:Activate(), MsgInfo( "Context menu is not defined !!!", 'OOHG IDE+' ) )
         ITEM "Form' notify menu"      ACTION IIF( HB_IsObject( ::myNMCtrl ), ::myNMCtrl:Activate(), MsgInfo( "Notify menu is not defined !!!", 'OOHG IDE+' ) )
      END MENU
      END MENU

      @ 420, 10 LABEL lop1 VALUE "Double click or Enter to modify the position or size of a control." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 435, 10 LABEL lop2 VALUE "Right click to access properties or events, or to do global" FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 450, 10 LABEL lop3 VALUE "align/resize of selected controls (use Ctrl+Click to select)." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
      @ 465, 10 LABEL lop4 VALUE "Click on the headers to change display order." FONT "Calibri" SIZE 9 AUTOSIZE HEIGHT 15
   END WINDOW

   // add first element
   ::nControlW ++
   ::IniArray( ::nControlW, "TEMPLATE", 'FORM' )

   ::oWaitMsg:Hide()
   CursorArrow()

   ::Form_Main:Show()
   ::cvcControls:Show()
   ::FormList:Show()
   ::oDesignForm:Show()
   ::FormList:Activate( .T. )
   ::oDesignForm:Activate( ! lWait )
RETURN NIL

//------------------------------------------------------------------------------
METHOD Exit() CLASS TFormEditor
//------------------------------------------------------------------------------
   IF ! ::lFsave
      IF MsgYesNo( 'Form not saved, save it now?', 'ooHG IDE+' )
         ::Save( 0 )
      ENDIF
   ENDIF
   // TODO: save windows positions and restore next time they're opened
   ::Form_Main:Release()
   ::cvcControls:Release()
   ::FormList:Release()
   ::oDesignForm:Release()
   _OOHG_DeleteArrayItem( ::myIde:aEditors, ::nEditorIndex )
   ::myIde:EditorExit()
RETURN NIL

//------------------------------------------------------------------------------
METHOD MinimizeForms() CLASS TFormEditor
//------------------------------------------------------------------------------
   ::Form_Main:Minimize()
   ::cvcControls:Minimize()
   ::FormList:Minimize()
RETURN NIL

//------------------------------------------------------------------------------
METHOD RestoreForms() CLASS TFormEditor
//------------------------------------------------------------------------------
   ::Form_Main:Restore()
   ::cvcControls:Restore()
   ::FormList:Restore()
RETURN NIL

//------------------------------------------------------------------------------
METHOD OrderControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName

   cName := _OOHG_GetNullName( "0" )
   SET INTERACTIVECLOSE ON
   LOAD WINDOW orderf AS ( cName )
   ::FormCtrlOrder := GetFormObject( cName )
   ON KEY ESCAPE OF ( ::FormCtrlOrder:Name ) ACTION ::FormCtrlOrder:Release()
   CENTER WINDOW ( cName )
   ACTIVATE WINDOW ( cName )
   SET INTERACTIVECLOSE OFF
   ::lOrdenFD := .F.
   ::MisPuntos()
   ::RefreshControlInspector()
RETURN NIL

//------------------------------------------------------------------------------
METHOD LlenaTipos() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i

   ::FormCtrlOrder:list_tipos:DeleteAllItems()
   ::FormCtrlOrder:list_tipos:Additem( 'Form' )
   FOR i := 1 TO ::nControlW
      IF ::aCtrlType[i] == 'TAB'
         ::FormCtrlOrder:list_tipos:AddItem( ::aControlW[i] )
      ENDIF
   NEXT i
   ::FormCtrlOrder:list_tipos:Value := 1
   ::LlenaCon()
RETURN NIL

//------------------------------------------------------------------------------
METHOD FilterDC() CLASS TFormEditor
//------------------------------------------------------------------------------
   ::lOrdenFD := ! ::lOrdenFD
   ::LlenaCon()
RETURN NIL

//------------------------------------------------------------------------------
METHOD LlenaCon() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL sw, wValue, cName, CurrentPage, j, aCaptions, i

   CursorWait()
   sw := 0
   wValue := ::FormCtrlOrder:list_tipos:Value
   ::FormCtrlOrder:TreeOrden:DeleteAllitems()
   IF wValue == 1
      sw := 1             // form
   ELSE
      cName := ::FormCtrlOrder:list_tipos:Item( wValue )
   ENDIF

   IF sw == 0             // TAB
      CurrentPage := 1
      j := aScan( ::aControlW, cName )
      aCaptions := &( ::aCaption[j] )
      ::FormCtrlOrder:TreeOrden:AddItem( 'page ' + aCaptions[CurrentPage] )
      FOR i := 2 TO ::nControlW
         IF ::aTabPage[i, 1] # NIL
            IF ::aTabPage[i, 1] == cName
               IF ::aTabPage[i, 2] # CurrentPage
                  CurrentPage := ::aTabPage[i, 2]
                  ::FormCtrlOrder:TreeOrden:AddItem( 'page ' + aCaptions[CurrentPage] )
               ENDIF
               IF ! ::lOrdenFD .OR. ! Upper( ::aCtrlType[i] ) $ "LABEL FRAME TIMER IMAGE"
                  ::FormCtrlOrder:TreeOrden:AddItem( '      ' + ::aName[i] )
               ENDIF
            ENDIF
         ENDIF
      NEXT i
      ::FormCtrlOrder:TreeOrden:Value := 2
   ELSE
      FOR i := 2 TO ::nControlW
         IF ( ::aTabPage[i, 2] == 0 .OR. ::aTabPage[i, 2] == NIL ) .AND. ::aControlW[i] # ''
            IF ! Upper( ::aControlW[i] ) $ 'STATUSBAR  MAINMENU CONTEXTMENU NOTIFYMENU'
               IF ! ::lOrdenFD .OR. ! Upper( ::aCtrlType[i] ) $ "LABEL FRAME TIMER IMAGE"
                  ::FormCtrlOrder:TreeOrden:AddItem( ::aName[i] )
               ENDIF
            ENDIF
         ENDIF
      NEXT i
      ::FormCtrlOrder:TreeOrden:Value := 1
   ENDIF
   CursorArrow()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Ord_Arriba() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL t, iabajo, iarriba, cControl1, cControl2, iPosicion1, iPosicion2

   iabajo := ::FormCtrlOrder:TreeOrden:Value
   IF iabajo == 1 .OR. iabajo == 0
      RETURN NIL
   ENDIF
   IF SubStr( ::FormCtrlOrder:TreeOrden:Item( iabajo ), 1, 4 )== 'page'
      RETURN NIL
   ENDIF
   iarriba    := iabajo - 1
   cControl1  := AllTrim( ::FormCtrlOrder:TreeOrden:Item( iabajo ) )
   cControl2  := AllTrim( ::FormCtrlOrder:TreeOrden:Item( iarriba ) )
   iPosicion1 := aScan( ::aName, cControl1 )
   iPosicion2 := aScan( ::aName, cControl2 )
   IF SubStr( ::FormCtrlOrder:TreeOrden:Item( iarriba ), 1, 1) # ' ' .AND. ::aTabPage[iposicion1, 2] # 0 .AND. ::aTabPage[iposicion1, 2] # NIL
      RETURN NIL
   ENDIF
   CursorWait()
   ::Swapea( iPosicion1, iPosicion2 )
   t := ::FormCtrlOrder:TreeOrden:Item( iabajo )
   ::FormCtrlOrder:TreeOrden:Item( iabajo, ::FormCtrlOrder:TreeOrden:Item( iarriba ) )
   ::FormCtrlOrder:TreeOrden:Item( iarriba, t )
   ::FormCtrlOrder:TreeOrden:Value := iarriba
   ::lFSave := .F.
   CursorArrow()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Ord_Abajo() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL t, iabajo, iarriba, cControl1, cControl2, iPosicion1, iPosicion2

   iarriba := ::FormCtrlOrder:TreeOrden:Value
   IF iarriba == ::FormCtrlOrder:TreeOrden:ItemCount() .OR. iarriba == 0
      RETURN NIL
   ENDIF
   IF SubStr( ::FormCtrlOrder:TreeOrden:Item( iarriba ), 1, 4) == 'page'
      RETURN NIL
   ENDIF
   iabajo     := iarriba + 1
   cControl1  := AllTrim( ::FormCtrlOrder:TreeOrden:Item( iarriba ) )
   cControl2  := AllTrim( ::FormCtrlOrder:TreeOrden:Item( iabajo ) )
   iPosicion1 := aScan( ::aName, cControl1 )
   iPosicion2 := aScan( ::aName, cControl2 )
   IF SubStr( ::FormCtrlOrder:TreeOrden:Item( iabajo ), 1, 1 ) # ' ' .AND. ::aTabPage[iposicion1, 2] # 0 .AND. ::aTabPage[iposicion1, 2] # NIL
      RETURN NIL
   ENDIF
   CursorWait()
   ::Swapea( iPosicion1, iPosicion2 )
   t := ::FormCtrlOrder:TreeOrden:Item( iarriba )
   ::FormCtrlOrder:TreeOrden:Item( iarriba, ::FormCtrlOrder:TreeOrden:Item( iabajo ) )
   ::FormCtrlOrder:TreeOrden:Item( iabajo, t )
   ::FormCtrlOrder:TreeOrden:Value := iabajo
   ::lFSave := .F.
   CursorArrow()
RETURN NIL

//------------------------------------------------------------------------------
METHOD Swapea( x1, x2 ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL t83, t84

   Cambia( ::a3State, x1, x2 )
   Cambia( ::aAction, x1, x2 )
   Cambia( ::aAction2, x1, x2 )
   Cambia( ::aAddress, x1, x2 )
   Cambia( ::aAfterColMove, x1, x2 )
   Cambia( ::aAfterColSize, x1, x2 )
   Cambia( ::aAppend, x1, x2 )
   Cambia( ::aAutoPlay, x1, x2 )
   Cambia( ::aBackColor, x1, x2 )
   Cambia( ::aBackground, x1, x2 )
   Cambia( ::aBeforeAutoFit, x1, x2 )
   Cambia( ::aBeforeColMove, x1, x2 )
   Cambia( ::aBeforeColSize, x1, x2 )
   Cambia( ::aBold, x1, x2 )
   Cambia( ::aBorder, x1, x2 )
   Cambia( ::aBoth, x1, x2 )
   Cambia( ::aBreak, x1, x2 )
   Cambia( ::aBuffer, x1, x2 )
   Cambia( ::aButtons, x1, x2 )
   Cambia( ::aButtonWidth, x1, x2 )
   Cambia( ::aByCell, x1, x2 )
   Cambia( ::aCancel, x1, x2 )
   Cambia( ::aCaption, x1, x2 )
   Cambia( ::aCenter, x1, x2 )
   Cambia( ::aCenterAlign, x1, x2 )
   Cambia( ::aCheckBoxes, x1, x2 )
   Cambia( ::aClientEdge, x1, x2 )
   Cambia( ::aCObj, x1, x2 )
   Cambia( ::aColumnControls, x1, x2 )
   Cambia( ::aColumnInfo, x1, x2 )
   Cambia( ::aControlW, x1, x2 )
   Cambia( ::aCtrlType, x1, x2 )
   Cambia( ::aDate, x1, x2 )
   Cambia( ::aDefaultYear, x1, x2 )
   Cambia( ::aDelayedLoad, x1, x2 )
   Cambia( ::aDelete, x1, x2 )
   Cambia( ::aDeleteMsg, x1, x2 )
   Cambia( ::aDeleteWhen, x1, x2 )
   Cambia( ::aDescend, x1, x2 )
   Cambia( ::aDIBSection, x1, x2 )
   Cambia( ::aDisplayEdit, x1, x2 )
   Cambia( ::aDoubleBuffer, x1, x2 )
   Cambia( ::aDrag, x1, x2 )
   Cambia( ::aDrop, x1, x2 )
   Cambia( ::aDynamicBackColor, x1, x2 )
   Cambia( ::aDynamicCtrls, x1, x2 )
   Cambia( ::aDynamicForeColor, x1, x2 )
   Cambia( ::aDynBlocks, x1, x2 )
   Cambia( ::aEdit, x1, x2 )
   Cambia( ::aEditKeys, x1, x2 )
   Cambia( ::aEditLabels, x1, x2 )
   Cambia( ::aEnabled, x1, x2 )
   Cambia( ::aExclude, x1, x2 )
   Cambia( ::aExtDblClick, x1, x2 )
   Cambia( ::aField, x1, x2 )
   Cambia( ::aFields, x1, x2 )
   Cambia( ::aFile, x1, x2 )
   Cambia( ::aFileType, x1, x2 )
   Cambia( ::aFirstItem, x1, x2 )
   Cambia( ::aFit, x1, x2 )
   Cambia( ::aFixBlocks, x1, x2 )
   Cambia( ::aFixedCols, x1, x2 )
   Cambia( ::aFixedCtrls, x1, x2 )
   Cambia( ::aFixedWidths, x1, x2 )
   Cambia( ::aFlat, x1, x2 )
   Cambia( ::aFocusedPos, x1, x2 )
   Cambia( ::aFocusRect, x1, x2 )
   Cambia( ::aFontColor, x1, x2 )
   Cambia( ::aFontItalic, x1, x2 )
   Cambia( ::aFontName, x1, x2 )
   Cambia( ::aFontSize, x1, x2 )
   Cambia( ::aFontStrikeout, x1, x2 )
   Cambia( ::aFontUnderline, x1, x2 )
   Cambia( ::aForceRefresh, x1, x2 )
   Cambia( ::aForceScale, x1, x2 )
   Cambia( ::aFull, x1, x2 )
   Cambia( ::aGripperText, x1, x2 )
   Cambia( ::aHandCursor, x1, x2 )
   Cambia( ::aHBitmap, x1, x2 )
   Cambia( ::aHeaderImages, x1, x2 )
   Cambia( ::aHeaders, x1, x2 )
   Cambia( ::aHelpID, x1, x2 )
   Cambia( ::aHotTrack, x1, x2 )
   Cambia( ::aImage, x1, x2 )
   Cambia( ::aImageMargin, x1, x2 )
   Cambia( ::aImagesAlign, x1, x2 )
   Cambia( ::aImageSize, x1, x2 )
   Cambia( ::aImageSource, x1, x2 )
   Cambia( ::aIncrement, x1, x2 )
   Cambia( ::aIncremental, x1, x2 )
   Cambia( ::aIndent, x1, x2 )
   Cambia( ::aInPlace, x1, x2 )
   Cambia( ::aInputMask, x1, x2 )
   Cambia( ::aInsertType, x1, x2 )
   Cambia( ::aIntegralHeight, x1, x2 )
   Cambia( ::aInvisible, x1, x2 )
   Cambia( ::aItemCount, x1, x2 )
   Cambia( ::aItemIDs, x1, x2 )
   Cambia( ::aItemImageNumber, x1, x2 )
   Cambia( ::aItemImages, x1, x2 )
   Cambia( ::aItems, x1, x2 )
   Cambia( ::aItemSource, x1, x2 )
   Cambia( ::aJustify, x1, x2 )
   Cambia( ::aLeft, x1, x2 )
   Cambia( ::aLikeExcel, x1, x2 )
   Cambia( ::aListWidth, x1, x2 )
   Cambia( ::aLock, x1, x2 )
   Cambia( ::aLowerCase, x1, x2 )
   Cambia( ::aMarquee, x1, x2 )
   Cambia( ::aMaxLength, x1, x2 )
   Cambia( ::aMultiLine, x1, x2 )
   Cambia( ::aMultiSelect, x1, x2 )
   Cambia( ::aName, x1, x2 )
   Cambia( ::aNo3DColors, x1, x2 )
   Cambia( ::aNoAutoSizeMovie, x1, x2 )
   Cambia( ::aNoAutoSizeWindow, x1, x2 )
   Cambia( ::aNoClickOnCheck, x1, x2 )
   Cambia( ::aNodeImages, x1, x2 )
   Cambia( ::aNoDelMsg, x1, x2 )
   Cambia( ::aNoErrorDlg, x1, x2 )
   Cambia( ::aNoFocusRect, x1, x2 )
   Cambia( ::aNoHeaders, x1, x2 )
   Cambia( ::aNoHideSel, x1, x2 )
   Cambia( ::aNoHScroll, x1, x2 )
   Cambia( ::aNoLines, x1, x2 )
   Cambia( ::aNoLoadTrans, x1, x2 )
   Cambia( ::aNoMenu, x1, x2 )
   Cambia( ::aNoModalEdit, x1, x2 )
   Cambia( ::aNoOpen, x1, x2 )
   Cambia( ::aNoPlayBar, x1, x2 )
   Cambia( ::aNoPrefix, x1, x2 )
   Cambia( ::aNoRClickOnCheck, x1, x2 )
   Cambia( ::aNoRefresh, x1, x2 )
   Cambia( ::aNoRootButton, x1, x2 )
   Cambia( ::aNoTabStop, x1, x2 )
   Cambia( ::aNoTicks, x1, x2 )
   Cambia( ::aNoToday, x1, x2 )
   Cambia( ::aNoTodayCircle, x1, x2 )
   Cambia( ::aNoVScroll, x1, x2 )
   Cambia( ::aNumber, x1, x2 )
   Cambia( ::aNumeric, x1, x2 )
   Cambia( ::aOnAbortEdit, x1, x2 )
   Cambia( ::aOnAppend, x1, x2 )
   Cambia( ::aOnChange, x1, x2 )
   Cambia( ::aOnCheckChg, x1, x2 )
   Cambia( ::aOnDblClick, x1, x2 )
   Cambia( ::aOnDelete, x1, x2 )
   Cambia( ::aOnDisplayChange, x1, x2 )
   Cambia( ::aOnDrop, x1, x2 )
   Cambia( ::aOnEditCell, x1, x2 )
   Cambia( ::aOnEnter, x1, x2 )
   Cambia( ::aOnGotFocus, x1, x2 )
   Cambia( ::aOnHeadClick, x1, x2 )
   Cambia( ::aOnHeadRClick, x1, x2 )
   Cambia( ::aOnHScroll, x1, x2 )
   Cambia( ::aOnLabelEdit, x1, x2 )
   Cambia( ::aOnListClose, x1, x2 )
   Cambia( ::aOnListDisplay, x1, x2 )
   Cambia( ::aOnLostFocus, x1, x2 )
   Cambia( ::aOnMouseMove, x1, x2 )
   Cambia( ::aOnQueryData, x1, x2 )
   Cambia( ::aOnRefresh, x1, x2 )
   Cambia( ::aOnSelChange, x1, x2 )
   Cambia( ::aOnTextFilled, x1, x2 )
   Cambia( ::aOnVScroll, x1, x2 )
   Cambia( ::aOpaque, x1, x2 )
   Cambia( ::aPageNames, x1, x2 )
   Cambia( ::aPageObjs, x1, x2 )
   Cambia( ::aPageSubClasses, x1, x2 )
   Cambia( ::aPassWord, x1, x2 )
   Cambia( ::aPicture, x1, x2 )
   Cambia( ::aPlainText, x1, x2 )
   Cambia( ::aPLM, x1, x2 )
   Cambia( ::aRange, x1, x2 )
   Cambia( ::aReadOnly, x1, x2 )
   Cambia( ::aReadOnlyB, x1, x2 )
   Cambia( ::aRecCount, x1, x2 )
   Cambia( ::aRefresh, x1, x2 )
   Cambia( ::aReplaceField, x1, x2 )
   Cambia( ::aRightAlign, x1, x2 )
   Cambia( ::aRTL, x1, x2 )
   Cambia( ::aSearchLapse, x1, x2 )
   Cambia( ::aSelBold, x1, x2 )
   Cambia( ::aSelColor, x1, x2 )
   Cambia( ::aShowAll, x1, x2 )
   Cambia( ::aShowMode, x1, x2 )
   Cambia( ::aShowName, x1, x2 )
   Cambia( ::aShowNone, x1, x2 )
   Cambia( ::aShowPosition, x1, x2 )
   Cambia( ::aSingleBuffer, x1, x2 )
   Cambia( ::aSingleExpand, x1, x2 )
   Cambia( ::aSmooth, x1, x2 )
   Cambia( ::aSort, x1, x2 )
   Cambia( ::aSourceOrder, x1, x2 )
   Cambia( ::aSpacing, x1, x2 )
   Cambia( ::aSpeed, x1, x2 )
   Cambia( ::aStretch, x1, x2 )
   Cambia( ::aSubClass, x1, x2 )
   Cambia( ::aSync, x1, x2 )
   Cambia( ::aTarget, x1, x2 )
   Cambia( ::aTextHeight, x1, x2 )
   Cambia( ::aThemed, x1, x2 )
   Cambia( ::aToolTip, x1, x2 )
   Cambia( ::aTop, x1, x2 )
   Cambia( ::aTransparent, x1, x2 )
   Cambia( ::aUnSync, x1, x2 )
   Cambia( ::aUpdate, x1, x2 )
   Cambia( ::aUpdateColors, x1, x2 )
   Cambia( ::aUpDown, x1, x2 )
   Cambia( ::aUpperCase, x1, x2 )
   Cambia( ::aValid, x1, x2 )
   Cambia( ::aValidMess, x1, x2 )
   Cambia( ::aValue, x1, x2 )
   Cambia( ::aValueL, x1, x2 )
   Cambia( ::aValueN, x1, x2 )
   Cambia( ::aValueSource, x1, x2 )
   Cambia( ::aVertical, x1, x2 )
   Cambia( ::aVirtual, x1, x2 )
   Cambia( ::aVisible, x1, x2 )
   Cambia( ::aWeekNumbers, x1, x2 )
   Cambia( ::aWhen, x1, x2 )
   Cambia( ::aWhiteBack, x1, x2 )
   Cambia( ::aWidths, x1, x2 )
   Cambia( ::aWorkArea, x1, x2 )
   Cambia( ::aWrap, x1, x2 )

   t83               := ::aTabPage[x1, 1]  // nombre del TAB al que pertenece
   t84               := ::aTabPage[x1, 2]  // n�mero de la p�gina
   ::aTabPage[x1, 1] := ::aTabPage[x2, 1]
   ::aTabPage[x1, 2] := ::aTabPage[x2, 2]
   ::aTabPage[x2, 1] := t83
   ::aTabPage[x2, 2] := t84
RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION Cambia( arreglo, x1, x2 )
//------------------------------------------------------------------------------
LOCAL t
   t           := arreglo[x1]
   arreglo[x1] := arreglo[x2]
   arreglo[x2] := t
RETURN NIL

//------------------------------------------------------------------------------
METHOD FrmFontColors() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, si := 0, FormFontColor

   cName := _OOHG_GetNullName( "0" )
   SET INTERACTIVECLOSE ON
   LOAD WINDOW fontclrs AS ( cName )
   FormFontColor := GetFormObject( cName )
   FormFontColor:label_1:Value := 'Form: ' + ::cFName
   ACTIVATE WINDOW ( cName )
   SET INTERACTIVECLOSE OFF
   ::oDesignForm:SetFocus()
RETURN NIL

//------------------------------------------------------------------------------
METHOD CtrlFontColors() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL si, cName, FormFontColor

   IF ::nHandleP > 0
      IF ::SiEsDEste( ::nHandleP, 'TIMER' ) .OR. ::SiEsDEste( ::nHandleP, 'PLAYER' ) .OR. ::SiEsDEste( ::nHandleP, 'ANIMATE' )
         RETURN NIL
      ENDIF

      si := aScan( ::aControlW, { |c| Lower( c ) == Lower( ::oDesignForm:aControls[::nHandleP]:Name ) } )
      IF si > 0
         cName := _OOHG_GetNullName( "0" )
         SET INTERACTIVECLOSE ON
         LOAD WINDOW fontclrs AS ( cName )
         FormFontColor := GetFormObject( cName )
         FormFontColor:label_1:Value := 'Control: ' + ::aName[si]
         IF ::aCtrlType[si] == 'PROGRESSBAR'
            FormFontColor:label_2:Visible := .T.
         ELSEIF ::aCtrlType[si] == 'IMAGE'
            FormFontColor:button_101:Visible := .F.
         ELSEIF ::aCtrlType[si] == 'PICCHECKBUTT'
            FormFontColor:button_101:Visible := .F.
         ELSEIF ::aCtrlType[si] == 'PICBUTT'
            FormFontColor:button_101:Visible := .F.
         ELSEIF ::aCtrlType[si] == 'MONTHCALENDAR'
            FormFontColor:button_103:Visible := .T.
            FormFontColor:button_104:Visible := .T.
            FormFontColor:button_105:Visible := .T.
            FormFontColor:button_106:Visible := .T.
         ELSEIF ::aCtrlType[si] == 'DATEPICKER'
            FormFontColor:button_102:Visible := .F.
            FormFontColor:button_107:Visible := .F.
         ELSEIF ::aCtrlType[si] == 'TIMEPICKER'
            FormFontColor:button_102:Visible := .F.
            FormFontColor:button_107:Visible := .F.
         ENDIF
         ACTIVATE WINDOW ( cName )
         SET INTERACTIVECLOSE OFF
         CHideControl( ::oDesignForm:aControls[::nHandleP] )
         CShowControl( ::oDesignForm:aControls[::nHandleP] )
         ::oDesignForm:SetFocus()
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD SetDefaultBackColor( si ) CLASS TFormEditor
//------------------------------------------------------------------------------
   IF si == 0
      ::cFBackcolor := 'NIL'
      ::oDesignForm:BackColor := NIL
      ::oDesignForm:Hide()
      ::oDesignForm:Show()
   ELSE
      ::aBackColor[si] := 'NIL'
      ::oDesignForm:aControlW[si]:BackColor := NIL
   ENDIF
   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD SetFontType( si )  CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, aFont, nRed, nGreen, nBlue, cColor, nFontColor

   IF si == 0
      aFont := GetFont( ::cFFontName, ::nFFontSize, .F. , .F. , { 0, 0, 0 } , .F., .F., 0 )
      IF aFont[1] == "" .AND. aFont[2] == 0 .AND. ( ! aFont[3] ) .AND.  ( ! aFont[4] ) .AND. ;
         aFont[5, 1] == NIL .AND. aFont[5,2] == NIL .AND.  aFont[5, 3] == NIL .AND. ;
         ( ! aFont[6] ) .AND. ( ! aFont[7]) .AND. aFont[8] == 0
         RETURN NIL
      ENDIF

      IF Len( aFont[1] ) > 0
         ::cFFontName := aFont[1]
         ::oDesignForm:cFontName := aFont[1]
      ENDIF
      IF aFont[2] > 0
         ::nFFontSize := aFont[2]
         ::oDesignForm:nFontSize := aFont[2]
      ENDIF
      nRed := aFont[5,1]
      nGreen := aFont[5,2]
      nBlue := aFont[5,3]
      IF nRed <> NIL .AND. nGreen <> NIL .AND. nBlue <> NIL
         cColor := '{ ' + LTrim( Str( nRed ) ) + ', ' + ;
                          LTrim( Str( nGreen ) ) + ', ' + ;
                          LTrim( Str( nBlue ) ) + ' }'
         ::cFFontColor := cColor
         ::oDesignForm:FontColor := &cColor
      ENDIF
   ELSEIF si == -1
      // Statusbar colors
      cName := 'statusbar'
      aFont := GetFont( ::cSFontName, ::nSFontSize, ::lSBold, ::lSItalic, { 0, 0, 0 }, ::lSUnderline, ::lSStrikeout, 0 )
      IF aFont[1] == "" .AND. aFont[2] == 0 .AND. ( ! aFont[3] ) .AND.  ( ! aFont[4] ) .AND. ;
         aFont[5, 1] == NIL .AND. aFont[5,2] == NIL .AND.  aFont[5, 3] == NIL .AND. ;
         ( ! aFont[6] ) .AND. ( ! aFont[7]) .AND. aFont[8] == 0
         RETURN NIL
      ENDIF

      IF Len( aFont[1] ) > 0
         ::cSFontName := aFont[1]
         ::oDesignForm:&cName:FontName := aFont[1]
      ENDIF
      IF aFont[2] > 0
         ::nSFontSize := aFont[2]
         ::oDesignForm:&cName:FontSize := aFont[2]
      ENDIF

      IF ::lSBold <> aFont[3]
         ::lSBold := aFont[3]
         ::oDesignForm:&cName:FontBold := aFont[3]
      ENDIF
      IF ::lSItalic <> aFont[4]
         ::lSItalic := aFont[4]
         ::oDesignForm:&cName:FontItalic := aFont[4]
      ENDIF
      IF ::lSUnderline <> aFont[6]
         ::lSUnderline := aFont[6]
         ::oDesignForm:&cName:FontUnderline := aFont[6]
      ENDIF
      IF ::lSStrikeout <> aFont[7]
         ::lSStrikeout := aFont[7]
         ::oDesignForm:&cName:FontStrikeout := aFont[7]
      ENDIF
   ELSE
      cName := ::aControlW[si]
      nFontColor := ::aFontColor[si]
      aFont := GetFont( ::aFontName[si], ::aFontSize[si], ::aBold[si], ::aFontItalic[si], &nFontColor, ::aFontUnderline[si], ::aFontStrikeout[si], 0 )
      IF aFont[1] == "" .AND. aFont[2] == 0 .AND. ( ! aFont[3] ) .AND.  ( ! aFont[4] ) .AND. ;
         aFont[5, 1] == NIL .AND. aFont[5,2] == NIL .AND.  aFont[5, 3] == NIL .AND. ;
         ( ! aFont[6] ) .AND. ( ! aFont[7]) .AND. aFont[8] == 0
         RETURN NIL
      ENDIF

      IF Len( aFont[1] ) > 0
         ::aFontName[si] := aFont[1]
         ::oDesignForm:&cName:FontName := aFont[1]
      ENDIF
      IF aFont[2] > 0
         ::aFontSize[si] := aFont[2]
         ::oDesignForm:&cName:FontSize := aFont[2]
      ENDIF

      IF ::aBold[si] <> aFont[3]
         ::aBold[si] := aFont[3]
         ::oDesignForm:&cName:FontBold := aFont[3]
      ENDIF
      IF ::aFontItalic[si] <> aFont[4]
         ::aFontItalic[si] := aFont[4]
         ::oDesignForm:&cName:FontItalic := aFont[4]
      ENDIF
      nRed := aFont[5,1]
      nGreen := aFont[5,2]
      nBlue := aFont[5,3]
      IF nRed <> NIL .AND. nGreen <> NIL .AND. nBlue <> NIL
         cColor := '{ ' + LTrim( Str( nRed ) ) + ', ' + ;
                          LTrim( Str( nGreen ) ) + ', ' + ;
                          LTrim( Str( nBlue ) ) + ' }'
         ::aFontColor[si] := cColor
         ::oDesignForm:&cName:FontColor := &cColor
      ENDIF
      IF ::aFontUnderline[si] <> aFont[6]
         ::aFontUnderline[si] := aFont[6]
         ::oDesignForm:&cName:FontUnderline := aFont[6]
      ENDIF
      IF ::aFontStrikeout[si] <> aFont[7]
         ::aFontStrikeout[si] := aFont[7]
         ::oDesignForm:&cName:FontStrikeout := aFont[7]
      ENDIF
   ENDIF
   ::lFSave := .F.
RETURN NIL

/*
   TODO: Add a function to reset font attributes to defaults.
         Add buttons to reset Name, Size and Color individually.
*/

//------------------------------------------------------------------------------
METHOD SetBackColor( si ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cCode, cBackColor, aColor

   IF si == 0
     cBackColor := ::cFBackcolor
   ELSE
     cBackColor := ::aBackColor[si]
   ENDIF
   IF Len( cBackColor ) > 0
      aColor := GetColor( &cBackColor )
   ELSE
      aColor := GetColor()
   ENDIF
   IF aColor[1] == NIL .AND. aColor[2] == NIL .AND. aColor[3] == NIL
      RETURN NIL
   ENDIF
   cCode := '{ ' + LTrim( Str( aColor[1] ) ) + ", " + ;
                   LTrim( Str( aColor[2] ) ) + ", " + ;
                   LTrim( Str( aColor[3] ) ) + " }"
   IF si == 0
      ::cFBackcolor := cCode
      ::oDesignForm:BackColor := &cCode
      ::oDesignForm:Hide()
      ::oDesignForm:Show()
   ELSE
      ::aBackColor[si] := cCode
      ::oDesignForm:aControlW[si]:BackColor := &cCode
   ENDIF
   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD GOtherColors( si, nColor ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cColor, aColor, cName

   IF ! ::aCtrlType[si] == 'MONTHCALENDAR'
      RETURN NIL
   ENDIF

   DO CASE
   CASE nColor == 1
      cColor := ::aTitleFontColor[si]
   CASE nColor == 2
      cColor := ::aTitleBackColor[si]
   CASE nColor == 3
      cColor := ::aTrailingFontColor[si]
   CASE nColor == 4
      cColor := ::aBackgroundColor[si]
   OTHERWISE
      RETURN NIL
   ENDCASE

   IF Len( cColor ) > 0
      aColor := GetColor( &cColor )
   ELSE
      aColor := GetColor()
   ENDIF
   IF aColor[1] == NIL .AND. aColor[2] == NIL .AND. aColor[3] == NIL
      RETURN NIL
   ENDIF
   cColor := '{ ' + LTrim( Str( aColor[1] ) ) + ", " + ;
                    LTrim( Str( aColor[2] ) ) + ", " + ;
                    LTrim( Str( aColor[3] ) ) + " }"

   IF ::aCtrlType[si] == 'MONTHCALENDAR'
      cName := ::aControlW[si]
      DO CASE
      CASE nColor == 1
         ::aTitleFontColor[si] := cColor
         ::oDesignForm:&cName:TitleFontColor := &cColor
      CASE nColor == 2
         ::aTitleBackColor[si] := cColor
         ::oDesignForm:&cName:TitleBackColor := &cColor
      CASE nColor == 3
         ::aTrailingFontColor[si] := cColor
         ::oDesignForm:&cName:TrailingFontColor := &cColor
      CASE nColor == 4
         ::aBackgroundColor[si] := cColor
         ::oDesignForm:&cName:BackgroundColor := &cColor
      OTHERWISE
         RETURN NIL
      ENDCASE
      ::lFSave := .F.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD VerifyBar() CLASS TFormEditor
//------------------------------------------------------------------------------
   IF ::lSStat
      ::cvcControls:Control_Stabusbar:Visible := .F.
      ::lSStat := .F.
      ::oDesignForm:Statusbar:Release()
   ELSE
      ::cvcControls:Control_Stabusbar:Visible := .T.
      ::lSStat := .T.
      ::CreateStatusBar()
   ENDIF
   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD CreateStatusBar() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL aCaptions, aWidths, aActions, aIcons, aStyles, aToolTips, aAligns, nCant, i

   TMessageBar():Define( "StatusBar", ::oDesignForm:Name, 0, 0, 0, 0, NIL, NIL, ;
         IIF( Empty( ::cSFontName ), NIL, ::cSFontName ), IIF( ::nSFontSize > 0, ::nSFontSize, NIL ), ;
         NIL, .F., .F., .F., NIL, NIL, ::lSBold, ::lSItalic, ::lSUnderline, ::lSStrikeout, ;
         ::lSTop, ::lSNoAutoAdjust, NIL, NIL, NIL, NIL )

      aCaptions := IIF( Empty( ::cSCaption ), {}, &( ::cSCaption ) )
      aWidths   := IF( Empty( ::cSWidth ), {}, &( ::cSWidth ) )
      aActions  := IF( Empty( ::cSAction ), {}, &( ::cSAction ) )
      aIcons    := IF( Empty( ::cSIcon ), {}, &( ::cSIcon ) )
      aStyles   := IF( Empty( ::cSStyle ), {}, &( ::cSStyle ) )
      aToolTips := IF( Empty( ::cSToolTip ), {}, &( ::cSToolTip ) )
      aAligns   := IF( Empty( ::cSAlign ), {}, &( ::cSAlign ) )

      nCant := Len( aCaptions )
      aSize( aWidths, nCant )
      aSize( aActions, nCant )
      aSize( aIcons, nCant )
      aSize( aStyles, nCant )
      aSize( aToolTips, nCant )
      aSize( aAligns, nCant )

      FOR i := 1 TO nCant
         _SetStatusItem( aCaptions[i], aWidths[i], NIL, aToolTips[i], aIcons[i], aStyles[i], aAligns[i] )
      NEXT i
      IF ::lSKeyboard
         _SetStatusKeybrd( ::nSKWidth, ::cSKToolTip, NIL, ::cSKImage, ::cSKStyle, ::cSKAlign )
      ENDIF
      IF ::lSDate
         _SetStatusItem( Dtoc( Date() ), IIF( ::nSDWidth > 0, ::nSDWidth, IIF( "yyyy" $ Lower( Set( _SET_DATEFORMAT ) ), 95, 75 ) ), NIL, ::cSDToolTip, NIL, ::cSDStyle, ::cSDAlign )
      ENDIF
      IF ::lSTime
         _SetStatusClock( ::nSCWidth, ::cSCToolTip, NIL, ::lSCAmPm, ::cSCImage, ::cSCStyle, ::cSCAlign )
      ENDIF
   END STATUSBAR
RETURN NIL

//------------------------------------------------------------------------------
METHOD StatPropEvents() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cTitle, aLabels, aInitValues, aFormats, aResults

   cTitle      := "Statusbar properties"
   aLabels     := { '**** STATUSBAR clauses', 'Obj',    'Top',   'NoAutoAdjust',   'SubClass',   '**** STATUSITEM clauses', 'Caption',  'Width',    'Action',   'Icon',   'Style',   'ToolTip',   'Align',   '**** DATE clauses', 'Date',   'Width',    'Action',    'ToolTip',    'Style',                                                             'Align',                                                                                              '**** CLOCK clauses', 'Clock',  'Width',    'Action',    'ToolTip',    'Icon',     'AmPm',    'Style',                                                             'Align',                                                                                              '**** KEYBOARD clauses', 'Keyboard',   'Width',    'Action',    'ToolTip',    'Icon',     'Style',                                                             'Align' }
   aInitValues := { NIL,                      ::cSCObj, ::lSTop, ::lSNoAutoAdjust, ::cSSubClass, NIL,                       ::cSCaption, ::cSWidth, ::cSAction, ::cSIcon, ::cSStyle, ::cSToolTip, ::cSAlign, NIL,                 ::lSDate, ::nSDWidth, ::cSDAction, ::cSDToolTip, IIF( ::cSDStyle == 'FLAT', 1, IIF( ::cSDStyle == 'RAISED', 2, 3 ) ), IIF( ::cSDAlign == 'CENTER', 1, IIF( ::cSDAlign == 'LEFT', 2, IIF( ::cSDAlign == 'RIGHT', 3, 4 ) ) ), NIL,                  ::lSTime, ::nSCWidth, ::cSCAction, ::cSCToolTip, ::cSCImage, ::lSCAmPm, IIF( ::cSCStyle == 'FLAT', 1, IIF( ::cSCStyle == 'RAISED', 2, 3 ) ), IIF( ::cSCAlign == 'CENTER', 1, IIF( ::cSCAlign == 'LEFT', 2, IIF( ::cSCAlign == 'RIGHT', 3, 4 ) ) ), NIL,                     ::lSKeyboard, ::nSKWidth, ::cSKAction, ::cSKToolTip, ::cSKImage, IIF( ::cSKStyle == 'FLAT', 1, IIF( ::cSKStyle == 'RAISED', 2, 3 ) ), IIF( ::cSKAlign == 'CENTER', 1, IIF( ::cSKAlign == 'LEFT', 2, IIF( ::cSKAlign == 'RIGHT', 3, 4 ) ) ) }
   aFormats    := { NIL,                      31,      .F.,    .F.,             250,             NIL,                       250,         250,       250,        250,      250,       250,         250,       NIL,                 .F.,      '9999',     250,         250,          { 'FLAT', 'RAISED', 'NONE' },                                        { 'CENTER', 'LEFT', 'RIGHT', 'NONE' },                                                                NIL,                  .F.,      '9999',     250,         250,          250,        .F.,       { 'FLAT', 'RAISED', 'NONE' },                                        { 'CENTER', 'LEFT', 'RIGHT', 'NONE' },                                                                NIL,                     .T.,          '9999',     250,         250,          250,        { 'FLAT', 'RAISED', 'NONE' },                                        { 'CENTER', 'LEFT', 'RIGHT', 'NONE' } }
   aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats, {|| ::SetFontType( -1 ) } )
   IF aResults[1] == NIL
      ::Control_Click( 1 )
      RETURN NIL
   ENDIF

   ::cSCObj         := aResults[02]
   ::lSTop          := aResults[03]
   ::lSNoAutoAdjust := aResults[04]
   ::cSSubClass     := aResults[05]
   ::cSCaption      := IIF( IsValidArray( aResults[07] ), aResults[07], ::cSCaption )
   ::cSWidth        := IIF( IsValidArray( aResults[08] ), aResults[08], ::cSWidth )
   ::cSAction       := IIF( IsValidArray( aResults[08] ), aResults[09], ::cSAction )
   ::cSIcon         := IIF( IsValidArray( aResults[10] ), aResults[10], ::cSIcon )
   ::cSStyle        := IIF( IsValidArray( aResults[11] ), aResults[11], ::cSStyle )
   ::cSToolTip      := IIF( IsValidArray( aResults[12] ), aResults[12], ::cSToolTip )
   ::cSAlign        := IIF( IsValidArray( aResults[13] ), aResults[13], ::cSAlign )
   ::lSDate         := aResults[15]
   ::nSDWidth       := aResults[16]
   ::cSDAction      := aResults[17]
   ::cSDToolTip     := aResults[18]
   ::cSDStyle       := IIF( aResults[19] == 1, 'FLAT', IIF( aResults[19] == 2, 'RAISED', '' ) )
   ::cSDAlign       := IIF( aResults[20] == 1, 'CENTER', IIF( aResults[20] == 2, 'LEFT', IIF( aResults[20] == 3, 'RIGHT', '' ) ) )
   ::lSTime         := aResults[22]
   ::nSCWidth       := aResults[23]
   ::cSCAction      := aResults[24]
   ::cSCToolTip     := aResults[25]
   ::cSCImage       := aResults[26]
   ::lSCAmPm        := aResults[27]
   ::cSCStyle       := IIF( aResults[28] == 1, 'FLAT', IIF( aResults[28] == 2, 'RAISED', '' ) )
   ::cSCAlign       := IIF( aResults[29] == 1, 'CENTER', IIF( aResults[29] == 2, 'LEFT', IIF( aResults[29] == 3, 'RIGHT', '' ) ) )
   ::lSKeyboard     := aResults[31]
   ::nSKWidth       := aResults[32]
   ::cSKAction      := aResults[33]
   ::cSKToolTip     := aResults[34]
   ::cSKImage       := aResults[35]
   ::cSKStyle       := IIF( aResults[36] == 1, 'FLAT', IIF( aResults[36] == 2, 'RAISED', '' ) )
   ::cSKAlign       := IIF( aResults[37] == 1, 'CENTER', IIF( aResults[37] == 2, 'LEFT', IIF( aResults[37] == 3, 'RIGHT', '' ) ) )

   ::oDesignForm:Statusbar:Release()
   ::CreateStatusBar()

   ::lFsave := .F.
   ::Control_Click( 1 )
RETURN NIL

//------------------------------------------------------------------------------
METHOD IniArray( z, controlname, ctypectrl, noanade ) CLASS TFormEditor
//------------------------------------------------------------------------------
   // inicia array de controles para la forma actual
   IF noanade == NIL
      aAdd( ::a3State, .F. )
      aAdd( ::aAction, "" )
      aAdd( ::aAction2, "" )
      aAdd( ::aAddress, "" )
      aAdd( ::aAfterColMove, "" )
      aAdd( ::aAfterColSize, "" )
      aAdd( ::aAppend, .F. )
      aAdd( ::aAutoPlay, .F. )
      aAdd( ::aBackColor, 'NIL' )
      aAdd( ::aBackground, '' )
      aAdd( ::aBackgroundColor, 'NIL' )
      aAdd( ::aBeforeAutoFit, "" )
      aAdd( ::aBeforeColMove, "" )
      aAdd( ::aBeforeColSize, "" )
      aAdd( ::aBold, .F. )
      aAdd( ::aBorder, .F. )
      aAdd( ::aBoth, .F. )
      aAdd( ::aBreak, .F. )
      aAdd( ::aBuffer, "" )
      aAdd( ::aButtons, .F. )
      aAdd( ::aButtonWidth, 0 )
      aAdd( ::aByCell, .F. )
      aAdd( ::aCancel, .F. )
      aAdd( ::aCaption, "" )
      aAdd( ::aCenter, .F. )
      aAdd( ::aCenterAlign, .F. )
      aAdd( ::aCheckBoxes, .F. )
      aAdd( ::aClientEdge, .F. )
      aAdd( ::aCObj, '' )
      aAdd( ::aColumnControls, "" )
      aAdd( ::aColumnInfo, "" )
      aAdd( ::aControlW, controlname )
      aAdd( ::aCtrlType, ctypectrl )
      aAdd( ::aDate, .F. )
      aAdd( ::aDefaultYear, 0 )
      aAdd( ::aDelayedLoad, .F. )
      aAdd( ::aDelete, .F. )
      aAdd( ::aDeleteMsg, "" )
      aAdd( ::aDeleteWhen, "" )
      aAdd( ::aDescend, .F. )
      aAdd( ::aDIBSection, .F. )
      aAdd( ::aDisplayEdit, .F. )
      aAdd( ::aDoubleBuffer, .F. )
      aAdd( ::aDrag, .F. )
      aAdd( ::aDrop, .F. )
      aAdd( ::aDynamicBackColor, "" )
      aAdd( ::aDynamicCtrls, .F. )
      aAdd( ::aDynamicForeColor, "" )
      aAdd( ::aDynBlocks, .F. )
      aAdd( ::aEdit, .F. )
      aAdd( ::aEditKeys, "" )
      aAdd( ::aEditLabels, .F. )
      aAdd( ::aEnabled, .T. )
      aAdd( ::aExclude, "" )
      aAdd( ::aExtDblClick, .F. )
      aAdd( ::aField, '' )
      aAdd( ::aFields, '' )
      aAdd( ::aFile, "" )
      aAdd( ::aFileType, 0 )
      aAdd( ::aFirstItem, .F. )
      aAdd( ::aFit, .F. )
      aAdd( ::aFixBlocks, .F. )
      aAdd( ::aFixedCols, .F. )
      aAdd( ::aFixedCtrls, .F. )
      aAdd( ::aFixedWidths, .F. )
      aAdd( ::aFlat, .F. )
      aAdd( ::aFocusedPos, -2 )
      aAdd( ::aFocusRect, .F. )
      aAdd( ::aFontColor, 'NIL' )
      aAdd( ::aFontItalic, .F. )
      aAdd( ::aFontName, "" )
      aAdd( ::aFontSize, 0 )
      aAdd( ::aFontStrikeout, .F. )
      aAdd( ::aFontUnderline, .F. )
      aAdd( ::aForceRefresh, .F. )
      aAdd( ::aForceScale, .F. )
      aAdd( ::aFull, .F. )
      aAdd( ::aGripperText, "" )
      aAdd( ::aHandCursor, .F. )
      aAdd( ::aHBitmap, "" )
      aAdd( ::aHeaderImages, "" )
      aAdd( ::aHeaders, "{'one', 'two'}" )
      aAdd( ::aHelpID, 0 )
      aAdd( ::aHotTrack, .F. )
      aAdd( ::aImage, '' )
      aAdd( ::aImageMargin, "" )
      aAdd( ::aImagesAlign, "" )
      aAdd( ::aImageSize, .F. )
      aAdd( ::aImageSource, "" )
      aAdd( ::aIncrement, 0 )
      aAdd( ::aIncremental, .F. )
      aAdd( ::aIndent, 0 )
      aAdd( ::aInPlace, .T. )
      aAdd( ::aInputMask, "" )
      aAdd( ::aInsertType, 0 )
      aAdd( ::aIntegralHeight, .F. )
      aAdd( ::aInvisible, .F. )
      aAdd( ::aItemCount, 0 )
      aAdd( ::aItemIDs, .F. )
      aAdd( ::aItemImageNumber, "" )
      aAdd( ::aItemImages, ''  )
      aAdd( ::aItems,  "" )
      aAdd( ::aItemSource, "" )
      aAdd( ::aJustify, '' )
      aAdd( ::aLeft, .F. )
      aAdd( ::aLikeExcel, .F. )
      aAdd( ::aListWidth, 0 )
      aAdd( ::aLock, .F. )
      aAdd( ::aLowerCase, .F. )
      aAdd( ::aMarquee, 0 )
      aAdd( ::aMaxLength, 30 )
      aAdd( ::aMultiLine, .F. )
      aAdd( ::aMultiSelect, .F. )
      aAdd( ::aName, controlname )
      aAdd( ::aNo3DColors, .F. )
      aAdd( ::aNoAutoSizeMovie, .F. )
      aAdd( ::aNoAutoSizeWindow, .F. )
      aAdd( ::aNoClickOnCheck, .F. )
      aAdd( ::aNodeImages, '' )
      aAdd( ::aNoDelMsg, .F. )
      aAdd( ::aNoErrorDlg, .F. )
      aAdd( ::aNoFocusRect, .F. )
      aAdd( ::aNoHeaders, .F. )
      aAdd( ::aNoHideSel, .F. )
      aAdd( ::aNoHScroll, .F. )
      aAdd( ::aNoLines, .F. )
      aAdd( ::aNoLoadTrans, .F. )
      aAdd( ::aNoMenu, .F. )
      aAdd( ::aNoModalEdit, .F. )
      aAdd( ::aNoOpen, .F. )
      aAdd( ::aNoPlayBar, .F. )
      aAdd( ::aNoPrefix, .F. )
      aAdd( ::aNoRClickOnCheck, .F. )
      aAdd( ::aNoRefresh, .F. )
      aAdd( ::aNoRootButton, .F. )
      aAdd( ::aNoTabStop, .F. )
      aAdd( ::aNoTicks, .F. )
      aAdd( ::aNoToday, .F. )
      aAdd( ::aNoTodayCircle, .F. )
      aAdd( ::aNoVScroll, .F. )
      aAdd( ::aNumber, 0 )
      aAdd( ::aNumeric, .F. )
      aAdd( ::aOnAbortEdit, "" )
      aAdd( ::aOnAppend, "" )
      aAdd( ::aOnChange, "" )
      aAdd( ::aOnCheckChg, "" )
      aAdd( ::aOnDblClick, "" )
      aAdd( ::aOnDelete, "" )
      aAdd( ::aOnDisplayChange, "" )
      aAdd( ::aOnDrop, "" )
      aAdd( ::aOnEditCell, "" )
      aAdd( ::aOnEnter, '' )
      aAdd( ::aOnGotFocus, "" )
      aAdd( ::aOnHeadClick, '' )
      aAdd( ::aOnHeadRClick, "" )
      aAdd( ::aOnHScroll, "" )
      aAdd( ::aOnLabelEdit, "" )
      aAdd( ::aOnListClose, "" )
      aAdd( ::aOnListDisplay, "" )
      aAdd( ::aOnLostFocus, "" )
      aAdd( ::aOnMouseMove, "" )
      aAdd( ::aOnQueryData, "" )
      aAdd( ::aOnRefresh, "" )
      aAdd( ::aOnSelChange, "" )
      aAdd( ::aOnTextFilled, "" )
      aAdd( ::aOnVScroll, "" )
      aAdd( ::aOpaque, .F. )
      aAdd( ::aPageNames, "" )
      aAdd( ::aPageObjs, "" )
      aAdd( ::aPageSubClasses, "" )
      aAdd( ::aPassWord, .F. )
      aAdd( ::aPicture, "" )
      aAdd( ::aPlainText, .F. )
      aAdd( ::aPLM, .F. )
      aAdd( ::aRange, "" )
      aAdd( ::aReadOnly, .F. )
      aAdd( ::aReadOnlyB, '' )
      aAdd( ::aRecCount, .F. )
      aAdd( ::aRefresh, .F. )
      aAdd( ::aReplaceField, "" )
      aAdd( ::aRightAlign, .F. )
      aAdd( ::aRTL, .F. )
      aAdd( ::aSearchLapse, 0 )
      aAdd( ::aSelBold, .F. )
      aAdd( ::aSelColor, "" )
      aAdd( ::aShowAll, .F. )
      aAdd( ::aShowMode, .F. )
      aAdd( ::aShowName, .F. )
      aAdd( ::aShowNone, .F. )
      aAdd( ::aShowPosition, .F. )
      aAdd( ::aSingleBuffer, .F. )
      aAdd( ::aSingleExpand, .F. )
      aAdd( ::aSmooth, .F. )
      aAdd( ::aSort, .F. )
      aAdd( ::aSourceOrder, "" )
      aAdd( ::aSpacing, 0 )
      aAdd( ::aSpeed, 1 )
      aAdd( ::aStretch, .F. )
      aAdd( ::aSubClass, "" )
      aAdd( ::aSync, .F. )
      aAdd( ::aTabPage, {'', 0} )
      aAdd( ::aTarget, "" )
      aAdd( ::aTextHeight, 0 )
      aAdd( ::aThemed, .F. )
      aAdd( ::aTitleBackColor, 'NIL' )
      aAdd( ::aTitleFontColor, 'NIL' )
      aAdd( ::aToolTip, "" )
      aAdd( ::aTop, .F. )
      aAdd( ::aTrailingFontColor, 'NIL' )
      aAdd( ::aTransparent, .T. )
      aAdd( ::aUnSync, .F. )
      aAdd( ::aUpdate, .F. )
      aAdd( ::aUpdateColors, .F. )
      aAdd( ::aUpDown, .F. )
      aAdd( ::aUpperCase, .F. )
      aAdd( ::aValid, '' )
      aAdd( ::aValidMess, '' )
      aAdd( ::aValue, "" )
      aAdd( ::aValueL, .F. )
      aAdd( ::aValueN, 0 )
      aAdd( ::aValueSource, "" )
      aAdd( ::aVertical, .F. )
      aAdd( ::aVirtual, .F. )
      aAdd( ::aVisible, .T. )
      aAdd( ::aWeekNumbers, .F. )
      aAdd( ::aWhen, '' )
      aAdd( ::aWhiteBack, .F. )
      aAdd( ::aWidths, '{ 60, 60 }' )
      aAdd( ::aWorkArea, 'Alias()' )
      aAdd( ::aWrap, .F. )
   ELSE
      myAdel( ::a3State, z )
      myAdel( ::aAction, z )
      myAdel( ::aAction2, z )
      myAdel( ::aAddress, z )
      myAdel( ::aAfterColMove, z )
      myAdel( ::aAfterColSize, z )
      myAdel( ::aAppend, z )
      myAdel( ::aAutoPlay, z )
      myAdel( ::aBackColor, z )
      myAdel( ::aBackground, z )
      myAdel( ::aBackgroundColor, z )
      myAdel( ::aBeforeAutoFit, z )
      myAdel( ::aBeforeColMove, z )
      myAdel( ::aBeforeColSize, z )
      myAdel( ::aBold, z )
      myAdel( ::aBorder, z )
      myAdel( ::aBoth, z )
      myAdel( ::aBreak, z )
      myAdel( ::aBuffer, z )
      myAdel( ::aButtons, z )
      myAdel( ::aButtonWidth, z )
      myAdel( ::aByCell, z )
      myAdel( ::aCancel, z )
      myAdel( ::aCaption, z )
      myAdel( ::aCenter, z )
      myAdel( ::aCenterAlign, z )
      myAdel( ::aCheckBoxes, z )
      myAdel( ::aClientEdge, z )
      myAdel( ::aCObj, z)
      myAdel( ::aColumnControls, z )
      myAdel( ::aColumnInfo, z )
      myAdel( ::aControlW, z )
      myAdel( ::aCtrlType, z )
      myAdel( ::aDate, z )
      myAdel( ::aDefaultYear, z )
      myAdel( ::aDelayedLoad, z )
      myAdel( ::aDelete, z )
      myAdel( ::aDeleteMsg, z )
      myAdel( ::aDeleteWhen, z )
      myAdel( ::aDescend, z )
      myAdel( ::aDIBSection, z )
      myAdel( ::aDisplayEdit, z )
      myAdel( ::aDoubleBuffer, z )
      myAdel( ::aDrag, z )
      myAdel( ::aDrop, z )
      myAdel( ::aDynamicBackColor, z )
      myAdel( ::aDynamicCtrls, z )
      myAdel( ::aDynamicForeColor, z )
      myAdel( ::aDynBlocks, z )
      myAdel( ::aEdit, z )
      myAdel( ::aEditKeys, z )
      myAdel( ::aEditLabels, z )
      myAdel( ::aEnabled, z )
      myAdel( ::aExclude, z )
      myAdel( ::aExtDblClick, z )
      myAdel( ::aField, z )
      myAdel( ::aFields, z )
      myAdel( ::aFile, z )
      myAdel( ::aFileType, z )
      myAdel( ::aFirstItem, z )
      myAdel( ::aFit, z )
      myAdel( ::aFixBlocks, z )
      myAdel( ::aFixedCols, z )
      myAdel( ::aFixedCtrls, z )
      myAdel( ::aFixedWidths, z )
      myAdel( ::aFlat, z )
      myAdel( ::aFocusedPos, z )
      myAdel( ::aFocusRect, z )
      myAdel( ::aFontColor, z )
      myAdel( ::aFontItalic, z )
      myAdel( ::aFontName, z )
      myAdel( ::aFontSize, z )
      myAdel( ::aFontStrikeout, z )
      myAdel( ::aFontUnderline, z )
      myAdel( ::aForceRefresh, z )
      myAdel( ::aForceScale, z )
      myAdel( ::aFull, z )
      myAdel( ::aGripperText, z )
      myAdel( ::aHandCursor, z )
      myAdel( ::aHBitmap, z )
      myAdel( ::aHeaderImages, z )
      myAdel( ::aHeaders, z )
      myAdel( ::aHelpID, z )
      myAdel( ::aHotTrack, z )
      myAdel( ::aImage, z )
      myAdel( ::aImageMargin, z )
      myAdel( ::aImagesAlign, z )
      myAdel( ::aImageSize, z )
      myAdel( ::aImageSource, z )
      myAdel( ::aIncrement, z )
      myAdel( ::aIncremental, z )
      myAdel( ::aIndent, z )
      myAdel( ::aInPlace, z )
      myAdel( ::aInputMask, z )
      myAdel( ::aInsertType, z )
      myAdel( ::aIntegralHeight, z )
      myAdel( ::aInvisible, z )
      myAdel( ::aItemCount, z )
      myAdel( ::aItemIDs, z )
      myAdel( ::aItemImageNumber, z )
      myAdel( ::aItemImages, z  )
      myAdel( ::aItems,  z )
      myAdel( ::aItemSource, z )
      myAdel( ::aJustify, z )
      myAdel( ::aLeft, z )
      myAdel( ::aLikeExcel, z )
      myAdel( ::aListWidth, z )
      myAdel( ::aLock, z )
      myAdel( ::aLowerCase, z )
      myAdel( ::aMarquee, z )
      myAdel( ::aMaxLength, z )
      myAdel( ::aMultiLine, z )
      myAdel( ::aMultiSelect, z )
      myAdel( ::aName, z )
      myAdel( ::aNo3DColors, z )
      myAdel( ::aNoAutoSizeMovie, z )
      myAdel( ::aNoAutoSizeWindow, z )
      myAdel( ::aNoClickOnCheck, z )
      myAdel( ::aNodeImages, z )
      myAdel( ::aNoDelMsg, z )
      myAdel( ::aNoErrorDlg, z )
      myAdel( ::aNoFocusRect, z )
      myAdel( ::aNoHeaders, z )
      myAdel( ::aNoHideSel, z )
      myAdel( ::aNoHScroll, z )
      myAdel( ::aNoLines, z )
      myAdel( ::aNoLoadTrans, z )
      myAdel( ::aNoMenu, z )
      myAdel( ::aNoModalEdit, z )
      myAdel( ::aNoOpen, z )
      myAdel( ::aNoPlayBar, z )
      myAdel( ::aNoPrefix, z )
      myAdel( ::aNoRClickOnCheck, z )
      myAdel( ::aNoRefresh, z )
      myAdel( ::aNoRootButton, z )
      myAdel( ::aNoTabStop, z )
      myAdel( ::aNoTicks, z )
      myAdel( ::aNoToday, z )
      myAdel( ::aNoTodayCircle, z )
      myAdel( ::aNoVScroll, z )
      myAdel( ::aNumber, z )
      myAdel( ::aNumeric, z )
      myAdel( ::aOnAbortEdit, z )
      myAdel( ::aOnAppend, z )
      myAdel( ::aOnChange, z )
      myAdel( ::aOnCheckChg, z )
      myAdel( ::aOnDblClick, z )
      myAdel( ::aOnDelete, z )
      myAdel( ::aOnDisplayChange, z )
      myAdel( ::aOnDrop, z )
      myAdel( ::aOnEditCell, z )
      myAdel( ::aOnEnter, z )
      myAdel( ::aOnGotFocus, z )
      myAdel( ::aOnHeadClick, z )
      myAdel( ::aOnHeadRClick, z )
      myAdel( ::aOnHScroll, z )
      myAdel( ::aOnLabelEdit, z )
      myAdel( ::aOnListClose, z )
      myAdel( ::aOnListDisplay, z )
      myAdel( ::aOnLostFocus, z )
      myAdel( ::aOnMouseMove, z )
      myAdel( ::aOnQueryData, z )
      myAdel( ::aOnRefresh, z )
      myAdel( ::aOnSelChange, z )
      myAdel( ::aOnTextFilled, z )
      myAdel( ::aOnVScroll, z )
      myAdel( ::aOpaque, z )
      myAdel( ::aPageNames, z )
      myAdel( ::aPageObjs, z )
      myAdel( ::aPageSubClasses, z )
      myAdel( ::aPassWord, z )
      myAdel( ::aPicture, z )
      myAdel( ::aPlainText, z )
      myAdel( ::aPLM, z )
      myAdel( ::aRange, z )
      myAdel( ::aReadOnly, z )
      myAdel( ::aReadOnlyB, z )
      myAdel( ::aRecCount, z )
      myAdel( ::aRefresh, z )
      myAdel( ::aReplaceField, z )
      myAdel( ::aRightAlign, z )
      myAdel( ::aRTL, z )
      myAdel( ::aSearchLapse, z )
      myAdel( ::aSelBold, z )
      myAdel( ::aSelColor, z )
      myAdel( ::aShowAll, z )
      myAdel( ::aShowMode, z )
      myAdel( ::aShowName, z )
      myAdel( ::aShowNone, z )
      myAdel( ::aShowPosition, z )
      myAdel( ::aSingleBuffer, z )
      myAdel( ::aSingleExpand, z )
      myAdel( ::aSmooth, z )
      myAdel( ::aSort, z )
      myAdel( ::aSourceOrder, z )
      myAdel( ::aSpacing, z )
      myAdel( ::aSpeed, z )
      myAdel( ::aStretch, z )
      myAdel( ::aSubClass, z )
      myAdel( ::aSync, z )
      myAdel( ::aTabPage, z )
      myAdel( ::aTarget, z )
      myAdel( ::aTextHeight, z )
      myAdel( ::aThemed, z )
      myAdel( ::aTitleBackColor, z )
      myAdel( ::aTitleFontColor, z )
      myAdel( ::aToolTip, z )
      myAdel( ::aTop, z )
      myAdel( ::aTrailingFontColor, z )
      myAdel( ::aTransparent, z )
      myAdel( ::aUnSync, z )
      myAdel( ::aUpdate, z )
      myAdel( ::aUpdateColors, z )
      myAdel( ::aUpDown, z )
      myAdel( ::aUpperCase, z )
      myAdel( ::aValid, z )
      myAdel( ::aValidMess, z )
      myAdel( ::aValue, z )
      myAdel( ::aValueL, z )
      myAdel( ::aValueN, z )
      myAdel( ::aValueSource, z )
      myAdel( ::aVertical, z )
      myAdel( ::aVirtual, z )
      myAdel( ::aVisible, z )
      myAdel( ::aWeekNumbers, z )
      myAdel( ::aWhen, z )
      myAdel( ::aWhiteBack, z )
      myAdel( ::aWidths, z )
      myAdel( ::aWorkArea, z )
      myAdel( ::aWrap, z )

      ::nControlW --
      IF ::nControlW == 1
         ::myHandle := 0
         ::nHandleP := 0
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
STATIC FUNCTION myaDel( arreglo, z )
//------------------------------------------------------------------------------
   aDel( arreglo, z )
   aSize( arreglo, Len( arreglo ) - 1 )
RETURN NIL

//------------------------------------------------------------------------------
METHOD MouseMoveSize() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, oControl, nl, cName, nRowAnterior, nColAnterior

   IF ::swCursor == 1
      IF ::myHandle > 0
         nl := 0
         FOR i := 1 TO len( ::oDesignForm:aControls )
            IF Lower( ::oDesignForm:aControls[i]:Name ) == Lower( ::aName[::myHandle] )
               nl := i
               EXIT
            ENDIF
         NEXT i
         IF nl == 0
            RETURN NIL
         ENDIF
         oControl := ::oDesignForm:aControls[nl]
         nRowAnterior := GetWindowRow( oControl:hWnd )
         nColAnterior := GetWindowCol( oControl:hWnd )
         EraseWindow( ::oDesignForm:Name )
         ::MisPuntos()
         InteractiveMoveHandle( oControl:hWnd )
         CHideControl( oControl:hWnd )
         oControl:Row := oControl:Row + GetWindowRow( oControl:hWnd ) - nRowAnterior
         oControl:Col := oControl:Col + GetWindowCol( oControl:hWnd ) - nColAnterior
         ::Snap( oControl:Name )
         ::lFSave := .F.
         CShowControl( ocontrol:hWnd )
         ::swCursor := 0
         cName := Lower( oControl:Name )
         i := aScan( ::aControlW, { |c| Lower( c ) == cName } )
         IF i > 0
            IF ::aTabPage[i, 2] # NIL
               IF ::aTabPage[i, 2] > 0
                  cName := ::aTabPage[i, 1]
                  ::oDesignForm:&cName:Show()
               ENDIF
            ENDIF
            ::Dibuja( oControl:Name )
          ENDIF
       ENDIF
   ELSEIF ::swCursor == 2
      IF ::myHandle > 0
         nl := 0
         FOR i := 1 TO Len( ::oDesignForm:aControls )
             IF Lower( ::oDesignForm:aControls[i]:Name )== Lower( ::aName[::myHandle] )
                nl := i
                EXIT
             ENDIF
         NEXT i
         IF nl == 0
            RETURN NIL
         ENDIF
         oControl := ::oDesignForm:aControls[nl]
         cName := Lower( oControl:Name )
         InteractiveSizeHandle( oControl:hWnd )
         CHideControl( oControl:hWnd )
         IF ::SiEsDEste( nl, 'RADIOGROUP' ) .OR. ::SiEsDEste( nl, 'COMBO' )
            oControl:Width := GetWindowWidth ( oControl:hWnd )
         ELSE
            oControl:Width := GetWindowWidth ( oControl:hWnd )
            oControl:Height := GetWindowHeight ( oControl:hWnd )
         ENDIF
         ::lFSave := .F.
         CShowControl( oControl:hWnd )
         ::swCursor := 0
         i := aScan( ::aControlW, { |c| Lower( c ) == cName } )
         IF i > 0
            IF ::aTabPage[i, 2] # NIL
               IF ::aTabPage[i, 2] > 0
                  cName := ::aTabPage[i, 1]
                  ::oDesignForm:&cName:Show()
               ENDIF
            ENDIF
            ::Dibuja( oControl:name )
         ENDIF
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD CopyControl( z ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, ControlName, oNewCtrl := NIL

   IF z > 1
      i := aScan( ::ControlType, ::aCtrlType[z] )
      IF i > 0
         ::ControlCount[i] ++
         ControlName := ::ControlPrefix[i] + LTrim( Str( ::ControlCount[i] ) )
         Do While _IsControlDefined( ControlName, ::oDesignForm:Name )
            ::ControlCount[i] ++
            ControlName := ::ControlPrefix[i] + LTrim( Str( ::ControlCount[i] ) )
         ENDDO
         ::nControlW ++

         aAdd( ::a3State,            ::a3State[z] )
         aAdd( ::aAction,            ::aAction[z] )
         aAdd( ::aAction2,           ::aAction2[z] )
         aAdd( ::aAddress,           ::aAddress[z] )
         aAdd( ::aAfterColMove,      ::aAfterColMove[z] )
         aAdd( ::aAfterColSize,      ::aAfterColSize[z] )
         aAdd( ::aAppend,            ::aAppend[z] )
         aAdd( ::aAutoPlay,          ::aAutoPlay[z] )
         aAdd( ::aBackColor,         ::aBackColor[z] )
         aAdd( ::aBackground,        ::aBackground[z] )
         aAdd( ::aBackgroundColor,   ::aBackgroundColor[z] )
         aAdd( ::aBeforeAutoFit,     ::aBeforeAutoFit[z] )
         aAdd( ::aBeforeColMove,     ::aBeforeColMove[z] )
         aAdd( ::aBeforeColSize,     ::aBeforeColSize[z] )
         aAdd( ::aBold,              ::aBold[z] )
         aAdd( ::aBorder,            ::aBorder[z] )
         aAdd( ::aBoth,              ::aBoth[z] )
         aAdd( ::aBreak,             ::aBreak[z] )
         aAdd( ::aBuffer,            ::aBuffer[z] )
         aAdd( ::aButtons,           ::aButtons[z] )
         aAdd( ::aButtonWidth,       ::aButtonWidth[z] )
         aAdd( ::aByCell,            ::aByCell[z] )
         aAdd( ::aCancel,            ::aCancel[z] )
         aAdd( ::aCaption,           ::aCaption[z] )
         aAdd( ::aCenter,            ::aCenter[z] )
         aAdd( ::aCenterAlign,       ::aCenterAlign[z] )
         aAdd( ::aCheckBox,          ::aCheckBox[z] )
         aAdd( ::aClientEdge,        ::aClientEdge[z] )
         aAdd( ::aCObj,              ::aCObj[z] )
         aAdd( ::aColumnControls,    ::aColumnControls[z] )
         aAdd( ::aColumnInfo,        ::aColumnInfo[z] )
         aAdd( ::aControlW,          ControlName )
         aAdd( ::aCtrlType,          ::aCtrlType[z] )
         aAdd( ::aDate,              ::aDate[z] )
         aAdd( ::aDefaultYear,       ::aDefaultYear[z] )
         aAdd( ::aDelayedLoad,       ::aDelayedLoad[z] )
         aAdd( ::aDelete,            ::aDelete[z] )
         aAdd( ::aDeleteMsg,         ::aDeleteMsg[z] )
         aAdd( ::aDeleteWhen,        ::aDeleteWhen[z] )
         aAdd( ::aDescend,           ::aDescend[z] )
         aAdd( ::aDIBSection,        ::aDIBSection[z] )
         aAdd( ::aDisplayEdit,       ::aDisplayEdit[z] )
         aAdd( ::aDoubleBuffer,      ::aDoubleBuffer[z] )
         aAdd( ::aDrag,              ::aDrag[z] )
         aAdd( ::aDrop,              ::aDrop[z] )
         aAdd( ::aDynamicBackColor,  ::aDynamicBackColor[z] )
         aAdd( ::aDynamicCtrls,      ::aDynamicCtrls[z] )
         aAdd( ::aDynamicForeColor,  ::aDynamicForeColor[z] )
         aAdd( ::aDynBlocks,         ::aDynBlocks[z] )
         aAdd( ::aEdit,              ::aEdit[z] )
         aAdd( ::aEditKeys,          ::aEditKeys[z] )
         aAdd( ::aEditLabels,        ::aEditLabels[z] )
         aAdd( ::aEnabled,           ::aEnabled[z] )
         aAdd( ::aExclude,           ::aExclude[z] )
         aAdd( ::aExtDblClick,       ::aExtDblClick[z] )
         aAdd( ::aField,             ::aField[z] )
         aAdd( ::aFields,            ::aFields[z] )
         aAdd( ::aFile,              ::aFile[z] )
         aAdd( ::aFileType,          ::aFileType[z] )
         aAdd( ::aFirstItem,         ::aFirstItem[z] )
         aAdd( ::aFit,               ::aFit[z] )
         aAdd( ::aFixBlocks,         ::aFixBlocks[z] )
         aAdd( ::aFixedCols,         ::aFixedCols[z] )
         aAdd( ::aFixedCtrls,        ::aFixedCtrls[z] )
         aAdd( ::aFixedWidths,       ::aFixedWidths[z] )
         aAdd( ::aFlat,              ::aFlat[z] )
         aAdd( ::aFocusedPos,        ::aFocusedPos[z] )
         aAdd( ::aFocusRect,         ::aFocusRect[z] )
         aAdd( ::aFontColor,         ::aFontColor[z] )
         aAdd( ::aFontItalic,        ::aFontItalic[z] )
         aAdd( ::aFontName,          ::aFontName[z] )
         aAdd( ::aFontSize,          ::aFontSize[z] )
         aAdd( ::aFontStrikeout,     ::aFontStrikeout[z] )
         aAdd( ::aFontUnderline,     ::aFontUnderline[z] )
         aAdd( ::aForceRefresh,      ::aForceRefresh[z] )
         aAdd( ::aForceScale,        ::aForceScale[z] )
         aAdd( ::aFull,              ::aFull[z] )
         aAdd( ::aGripperText,       ::aGripperText[z] )
         aAdd( ::aHandCursor,        ::aHandCursor[z] )
         aAdd( ::aHBitmap,           ::aHBitmap[z] )
         aAdd( ::aHeaderImages,      ::aHeaderImages[z] )
         aAdd( ::aHeaders,           ::aHeaders[z] )
         aAdd( ::aHelpID,            ::aHelpID[z] )
         aAdd( ::ahottrack,          ::ahottrack[z] )
         aAdd( ::aImage,             ::aImage[z] )
         aAdd( ::aImageMargin,       ::aImageMargin[z] )
         aAdd( ::aImagesAlign,       ::aImagesAlign[z] )
         aAdd( ::aImageSize,         ::aImageSize[z] )
         aAdd( ::aImageSource,       ::aImageSource[z] )
         aAdd( ::aIncrement,         ::aIncrement[z] )
         aAdd( ::aIncremental,       ::aIncremental[z] )
         aAdd( ::aIndent,            ::aIndent[z] )
         aAdd( ::aInPlace,           ::aInPlace[z] )
         aAdd( ::aInputMask,         ::aInputMask[z] )
         aAdd( ::aInsertType,        ::aInsertType[z] )
         aAdd( ::aIntegralHeight,    ::aIntegralHeight[z] )
         aAdd( ::aInvisible,         ::aInvisible[z] )
         aAdd( ::aItemCount,         ::aItemCount[z] )
         aAdd( ::aItemIDs,           ::aItemIDs[z] )
         aAdd( ::aItemImageNumber,   ::aItemImageNumber[z] )
         aAdd( ::aItemImages,        ::aItemImages[z] )
         aAdd( ::aItems,             ::aItems[z] )
         aAdd( ::aItemSource,        ::aItemSource[z] )
         aAdd( ::aJustify,           ::aJustify[z] )
         aAdd( ::aLeft,              ::aLeft[z] )
         aAdd( ::aLikeExcel,         ::aLikeExcel[z] )
         aAdd( ::aListWidth,         ::aListWidth[z] )
         aAdd( ::aLock,              ::aLock[z] )
         aAdd( ::aLowerCase,         ::aLowerCase[z] )
         aAdd( ::aMarquee,           ::aMarquee[z] )
         aAdd( ::aMaxLength,         ::aMaxLength[z] )
         aAdd( ::aMultiLine,         ::aMultiLine[z] )
         aAdd( ::aMultiSelect,       ::aMultiSelect[z] )
         aAdd( ::aName,              ControlName )
         aAdd( ::aNo3DColors,        ::aNo3DColors[z] )
         aAdd( ::aNoAutoSizeMovie,   ::aNoAutoSizeMovie[z] )
         aAdd( ::aNoAutoSizeWindow,  ::aNoAutoSizeWindow[z] )
         aAdd( ::aNoClickOnCheck,    ::aNoClickOnCheck[z] )
         aAdd( ::aNodeImages,        ::aNodeImages[z] )
         aAdd( ::aNoDelMsg,          ::aNoDelMsg[z] )
         aAdd( ::aNoErrorDlg,        ::aNoErrorDlg[z] )
         aAdd( ::aNoFocusRect,       ::aNoFocusRect[z] )
         aAdd( ::aNoHeaders,         ::aNoHeaders[z] )
         aAdd( ::aNoHideSel,         ::aNoHideSel[z] )
         aAdd( ::aNoHScroll,         ::aNoHScroll[z] )
         aAdd( ::anolines,           ::anolines[z] )
         aAdd( ::aNoLoadTrans,       ::aNoLoadTrans[z] )
         aAdd( ::aNoMenu,            ::aNoMenu[z] )
         aAdd( ::aNoModalEdit,       ::aNoModalEdit[z] )
         aAdd( ::aNoOpen,            ::aNoOpen[z] )
         aAdd( ::aNoPlayBar,         ::aNoPlayBar[z] )
         aAdd( ::aNoPrefix,          ::aNoPrefix[z] )
         aAdd( ::aNoRClickOnCheck,   ::aNoRClickOnCheck[z] )
         aAdd( ::aNoRefresh,         ::aNoRefresh[z] )
         aAdd( ::aNoRootButton,      ::aNoRootButton[z] )
         aAdd( ::anotabstop,         ::anotabstop[z] )
         aAdd( ::aNoTicks,           ::aNoTicks[z] )
         aAdd( ::aNoToday,           ::aNoToday[z] )
         aAdd( ::aNoTodayCircle,     ::aNoTodayCircle[z] )
         aAdd( ::Anovscroll,         ::Anovscroll[z] )
         aAdd( ::aNumber,            ::aNumber[z] )
         aAdd( ::aNumeric,           ::aNumeric[z] )
         aAdd( ::aOnAbortEdit,       ::aOnAbortEdit[z] )
         aAdd( ::aOnAppend,          ::aOnAppend[z] )
         aAdd( ::aOnChange,          ::aOnChange[z] )
         aAdd( ::aOnCheckChg,        ::aOnCheckChg[z] )
         aAdd( ::aOnDblClick,        ::aOnDblClick[z] )
         aAdd( ::aOnDelete,          ::aOnDelete[z] )
         aAdd( ::aOnDisplayChange,   ::aOnDisplayChange[z] )
         aAdd( ::aOnDrop,            ::aOnDrop[z] )
         aAdd( ::aOnEditCell,        ::aOnEditCell[z] )
         aAdd( ::aonenter,           ::aonenter[z] )
         aAdd( ::aOnGotFocus,        ::aOnGotFocus[z] )
         aAdd( ::aOnHeadClick,       ::aOnHeadClick[z] )
         aAdd( ::aOnHeadRClick,      ::aOnHeadRClick[z] )
         aAdd( ::aOnHScroll,         ::aOnHScroll[z] )
         aAdd( ::aOnLabelEdit,       ::aOnLabelEdit[z] )
         aAdd( ::aOnListClose,       ::aOnListClose[z] )
         aAdd( ::aOnListDisplay,     ::aOnListDisplay[z] )
         aAdd( ::aOnLostFocus,       ::aOnLostFocus[z] )
         aAdd( ::aOnMouseMove,       ::aOnMouseMove[z] )
         aAdd( ::aOnQueryData,       ::aOnQueryData[z] )
         aAdd( ::aOnRefresh,         ::aOnRefresh[z] )
         aAdd( ::aOnSelChange,       ::aOnSelChange[z] )
         aAdd( ::aOnTextFilled,      ::aOnTextFilled[z] )
         aAdd( ::aOnVScroll,         ::aOnVScroll[z] )
         aAdd( ::aOpaque,            ::aOpaque[z] )
         aAdd( ::aPageNames,         ::aPageNames[z] )
         aAdd( ::aPageObjs,          ::aPageObjs[z] )
         aAdd( ::aPageSubClasses,    ::aPageSubClasses[z] )
         aAdd( ::aPassWord,          ::aPassWord[z] )
         aAdd( ::aPicture,           ::aPicture[z] )
         aAdd( ::aPlainText,         ::aPlainText[z] )
         aAdd( ::aPLM,               ::aPLM[z] )
         aAdd( ::aRange,             ::aRange[z] )
         aAdd( ::aReadOnly,          ::aReadOnly[z] )
         aAdd( ::aReadOnlyB,         ::aReadOnlyB[z] )
         aAdd( ::aRecCount,          ::aRecCount[z] )
         aAdd( ::aRefresh,           ::aRefresh[z] )
         aAdd( ::aReplaceField,      ::aReplaceField[z] )
         aAdd( ::aRightAlign,        ::aRightAlign[z] )
         aAdd( ::aRTL,               ::aRTL[z] )
         aAdd( ::aSearchLapse,       ::aSearchLapse[z] )
         aAdd( ::aSelBold,           ::aSelBold[z] )
         aAdd( ::aSelColor,          ::aSelColor[z] )
         aAdd( ::aShowAll,           ::aShowAll[z] )
         aAdd( ::aShowMode,          ::aShowMode[z] )
         aAdd( ::aShowName,          ::aShowName[z] )
         aAdd( ::aShowNone,          ::aShowNone[z] )
         aAdd( ::aShowPosition,      ::aShowPosition[z] )
         aAdd( ::aSingleBuffer,      ::aSingleBuffer[z] )
         aAdd( ::aSingleExpand,      ::aSingleExpand[z] )
         aAdd( ::aSmooth,            ::aSmooth[z] )
         aAdd( ::aSort,              ::aSort[z] )
         aAdd( ::aSourceOrder,       ::aSourceOrder[z] )
         aAdd( ::aSpacing,           ::aSpacing[z] )
         aAdd( ::aSpeed,             ::aSpeed[z] )
         aAdd( ::aStretch,           ::aStretch[z] )
         aAdd( ::aSubClass,          ::aSubClass[z] )
         aAdd( ::aSync,              ::aSync[z] )
         aAdd( ::aTabPage,           ::aTabPage[z] )
         aAdd( ::aTarget,            ::aTarget[z] )
         aAdd( ::aTextHeight,        ::aTextHeight[z] )
         aAdd( ::aThemed,            ::aThemed[z] )
         aAdd( ::aTitleBackColor,    ::aTitleBackColor[z] )
         aAdd( ::aTitleFontColor,    ::aTitleFontColor[z] )
         aAdd( ::aToolTip,           ::aToolTip[z] )
         aAdd( ::aTop,               ::aTop[z] )
         aAdd( ::aTrailingFontColor, ::aTrailingFontColor[z] )
         aAdd( ::aTransparent,       ::aTransparent[z] )
         aAdd( ::aUnSync,            ::aUnSync[z] )
         aAdd( ::aUpdate,            ::aUpdate[z] )
         aAdd( ::aUpdateColors,      ::aUpdateColors[z] )
         aAdd( ::aUpDown,            ::aUpDown[z] )
         aAdd( ::aUpperCase,         ::aUpperCase[z] )
         aAdd( ::avalid,             ::avalid[z] )
         aAdd( ::aValidMess,         ::aValidMess[z] )
         aAdd( ::avalue,             ::avalue[z] )
         aAdd( ::avaluel,            ::avaluel[z] )
         aAdd( ::avaluen,            ::avaluen[z] )
         aAdd( ::avaluesource,       ::avaluesource[z] )
         aAdd( ::aVertical,          ::aVertical[z] )
         aAdd( ::aVirtual,           ::aVirtual[z] )
         aAdd( ::aVisible,           ::aVisible[z] )
         aAdd( ::aWeekNumbers,       ::aWeekNumbers[z] )
         aAdd( ::aWhen,              ::aWhen[z] )
         aAdd( ::aWhiteBack,         ::aWhiteBack[z] )
         aAdd( ::aWidths,            ::aWidths[z] )
         aAdd( ::aWorkArea,          ::aWorkArea[z] )
         aAdd( ::aWrap,              ::aWrap[z] )

         oNewCtrl := ::CreateControl( i, ::nControlW )
         ::ProcessContainers( ControlName )
         ::lFSave := .F.
         ::Dibuja( oNewCtrl:Name )
         ::RefreshControlInspector()
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ProcessContainers( ControlName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, ActivePage, k, k1, oControl, aControls, cvc, nDesRow, nDesCol, oCN

   IF ::swTab
      aControls := ::oDesignForm:aControls
      FOR i := 1 TO Len( aControls )
         oControl := aControls[i]
         IF oControl:Type == 'TAB'
            nDesRow := oControl:Row   // coordenada del tab para desplazamiento del mouse
            nDesCol := oControl:Col
            IF ( _OOHG_MouseRow > nDesRow ) .AND. (_OOHG_MouseRow < nDesRow + oControl:Height ) .AND. ;
               ( _OOHG_MouseCol > nDesCol ) .AND. ( _OOHG_MouseCol < nDesCol + oControl:Width )
               ActivePage := oControl:Value
               oCN := ::oDesignForm:&ControlName:Object()
               aAdd( oControl:aPages[ActivePage], oCN )
               oControl:AddControl( ControlName, ActivePage, _OOHG_MouseRow - nDesRow, _OOHG_MouseCol - nDesCol )
               oCN:BackColor := ::myIde:aSystemColorAux         // TODO: Check

               cvc := aScan( ::aControlW, { |c| Lower( c ) == Lower( ControlName ) } )
               IF cvc > 0
                  ::aBackColor[cvc] := 'NIL'
                  ::aTabPage[cvc, 1] := Lower( oControl:Name )
                  ::aTabPage[cvc, 2] := Activepage
               ENDIF
               FOR k := 2 TO ::nControlW
                  FOR k1 := k + 1 TO ::nControlW
                     IF ::aTabPage[k, 1] # NIL .AND. ::aTabPage[k1, 1] # NIL
                        IF ::aTabPage[k, 1] > ::aTabPage[k1, 1]
                           ::Swapea( k, k1 )
                        ENDIF
                     ENDIF
                  NEXT k1
               NEXT k
               FOR k := 2 TO ::nControlW
                  FOR k1 := k + 1 TO ::nControlW
                     IF ::aTabPage[k, 1] # NIL .AND. ::aTabPage[k1, 1] # NIL
                        IF ::aTabPage[k, 1] == ::aTabPage[k1, 1]
                           IF ::aTabPage[k, 2] > ::aTabPage[k1, 2]
                              ::Swapea( k, k1 )
                           ENDIF
                        ENDIF
                     ENDIF
                  NEXT k1
               NEXT k

               CHideControl( oCN:hWnd )
               CShowControl( oCN:hWnd )
            ENDIF

            EXIT
         ENDIF
      NEXT i
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD CheckIfIsFrame() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, o, SupMin, w_OOHG_MouseRow, w_OOHG_MouseCol, cName

   w_OOHG_MouseRow := _OOHG_MouseRow  - GetBorderHeight()
   w_OOHG_MouseCol := _OOHG_MouseCol  - GetBorderWidth()
   SupMin          := 99999999
   cName           := ''

   FOR i := 1 TO Len( ::oDesignForm:aControls )
      o := ::oDesignForm:aControls[i]
      IF o:row == o:ContainerRow .AND. o:Col == o:ContainerCol
         IF w_OOHG_MouseRow >= o:Row .AND. w_OOHG_MouseRow <= o:Row + o:Height .AND. ;
            w_OOHG_MouseCol >= o:Col .AND. w_OOHG_MouseCol <= o:Col+ o:Width .AND. ;
            o:Type == 'FRAME' .AND. IsWindowVisible( o:hWnd )
            IF SupMin > o:Height * o:Width
               SupMin := o:Height * o:Width
               cName := o:Name
            ENDIF
         ENDIF
      ELSE
         IF w_OOHG_MouseRow >= o:ContainerRow .AND. w_OOHG_MouseRow <= o:ContainerRow + o:Height .AND. ;
            w_OOHG_MouseCol >= o:ContainerCol .AND. w_OOHG_MouseCol <= o:ContainerCol+ o:Width .AND. ;
            o:Type == 'FRAME' .AND. IsWindowVisible( o:hWnd )
            IF SupMin > o:Height * o:Width
               SupMin := o:Height * o:Width
               cName := o:Name
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cName

//------------------------------------------------------------------------------
METHOD AddControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL x, ControlName, oNewCtrl

// TODO: control defined here must be equal to control defined in p(Control) methods

   IF ::CurrentControl == 1
      IF ! Empty( x := ::CheckIfIsFrame() )
         ::Dibuja( x )
      ENDIF
      RETURN NIL
   ELSEIF ::CurrentControl >= 2 .AND. ::CurrentControl <= 31
      ::ControlCount[::CurrentControl] ++
      ControlName := ::ControlPrefix[::CurrentControl] + LTrim( Str( ::ControlCount[::CurrentControl] ) )
      Do While _IsControlDefined( ControlName, ::oDesignForm:Name )
         ::ControlCount[::CurrentControl] ++
         ControlName := ::ControlPrefix[::CurrentControl] + LTrim( Str( ::ControlCount[::CurrentControl] ) )
      ENDDO
      ::nControlW ++
      ::IniArray( ::nControlW, ControlName, ::ControlType[::CurrentControl] )

      DO CASE
      CASE ::CurrentControl == 2
         // BUTTON
         ::aCaption[::nControlW]   := ControlName
         ::aAction[::nControlW]    := "MsgInfo( 'Button pressed' )"
         ::aBackColor[::nControlW] := ::cFBackcolor            // TODO:: Check if this is needed

      CASE ::CurrentControl == 3
         // CHECKBOX
      CASE ::CurrentControl == 4
         // LIST
      CASE ::CurrentControl == 5
         // COMBO
      CASE ::CurrentControl == 6
         // CHECKBTN
      CASE ::CurrentControl == 7
         // GRID
      CASE ::CurrentControl == 8
         // FRAME
         ::aTransparent[::nControlW] := .T.

      CASE ::CurrentControl == 9
         // TAB
         ::aCaption[::nControlW] := "{ 'Page 1', 'Page 2' }"
         ::aImage[::nControlW] := "{ '', '' }"

      CASE ::CurrentControl == 10
         // IMAGE
      CASE ::CurrentControl == 11
         // ANIMATE
      CASE ::CurrentControl == 12
         // DATEPICKER
      CASE ::CurrentControl == 13
         // TEXT
      CASE ::CurrentControl == 14
         // EDIT
      CASE ::CurrentControl == 15
         // LABEL
         ::aTransparent[::nControlW] := .T.

      CASE ::CurrentControl == 16
         // PLAYER
      CASE ::CurrentControl == 17
         // PROGRESSBAR
      CASE ::CurrentControl == 18
         // RADIOGROUP
         ::aItems[::nControlW]     := "{ 'option 1', 'option 2' }"
         ::aSpacing[::nControlW]   := 25
         ::aBackColor[::nControlW] := ::cFBackcolor                                                       // TODO:: Check if this is needed

      CASE ::CurrentControl == 19
         // SLIDER
         ::aBackColor[::nControlW] := ::cFBackcolor                                                       // TODO:: Check if this is needed

      CASE ::CurrentControl == 20
         // SPINNER
      CASE ::CurrentControl == 21
         // PICCHECKBUTT
      CASE ::CurrentControl == 22
         // PICBUTT
         ::aAction[::nControlW] := "MsgInfo( 'Pic button pressed' )"

      CASE ::CurrentControl == 23
         // TIMER
      CASE ::CurrentControl == 24
         // BROWSE
      CASE ::CurrentControl == 25
         // TREE
      CASE ::CurrentControl == 26
         // IPADDRESS
      CASE ::CurrentControl == 27
         // MONTHCALENDAR
      CASE ::CurrentControl == 28
         // HYPERLINK
      CASE ::CurrentControl == 29
         // RICHEDIT
      CASE ::CurrentControl == 30
         // TIMEPICKER
      CASE ::CurrentControl == 31
         // XBROWSE
      ENDCASE

      oNewCtrl := ::CreateControl( ::CurrentControl, ::nControlW )
      ::ProcessContainers( ControlName )
      ::lFSave := .F.
      oNewCtrl:SetFocus()
      ::RefreshControlInspector()
      ::Control_Click( 1 )
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD CreateControl( nControlType, i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL ControlName, oCtrl

   ControlName := ::aControlW[i]
// TODO: control defined here must be equal to the controls defined in p(Control) methods

   DO CASE
   CASE nControlType == 2            // BUTTON
      IF ::aRTL[i]
         IF ::aFlat[i]
            IF ::aNoPrefix[i]
               IF ::aMultiLine[i]
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     RTL ;
                     FLAT ;
                     NOPREFIX ;
                     MULTILINE ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ELSE
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     RTL ;
                     FLAT ;
                     NOPREFIX ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ENDIF
            ELSE
               IF ::aMultiLine[i]
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     RTL ;
                     FLAT ;
                     MULTILINE ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ELSE
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     RTL ;
                     FLAT ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ENDIF
            ENDIF
         ELSE
            IF ::aNoPrefix[i]
               IF ::aMultiLine[i]
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     RTL ;
                     NOPREFIX ;
                     MULTILINE ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ELSE
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     RTL ;
                     NOPREFIX ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ENDIF
            ELSE
               IF ::aMultiLine[i]
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     RTL ;
                     MULTILINE ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ELSE
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     RTL ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ENDIF
            ENDIF
         ENDIF
      ELSE
         IF ::aFlat[i]
            IF ::aNoPrefix[i]
               IF ::aMultiLine[i]
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     FLAT ;
                     NOPREFIX ;
                     MULTILINE ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ELSE
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     FLAT ;
                     NOPREFIX ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ENDIF
            ELSE
               IF ::aMultiLine[i]
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     FLAT ;
                     MULTILINE ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ELSE
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     FLAT ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ENDIF
            ENDIF
         ELSE
            IF ::aNoPrefix[i]
               IF ::aMultiLine[i]
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     NOPREFIX ;
                     MULTILINE ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ELSE
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     NOPREFIX ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ENDIF
            ELSE
               IF ::aMultiLine[i]
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     MULTILINE ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ELSE   // ! lMultiLine
                  @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
                     CAPTION ::aCaption[i] ;
                     ON GOTFOCUS ::Dibuja( This:Name ) ;
                     ACTION ::Dibuja( This:Name )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
/*
      TODO: Implement this properties

      ::aPicture[i]       := cPicture
      ::aNoLoadTrans[i]   := lNoLoadTrans
      ::aForceScale[i]    := lForceScale
      ::aCancel[i]        := lCancel
      ::aNo3DColors[i]    := lNo3DColors
      ::aFit[i]           := lFit
      ::aDIBSection[i]    := lDIBSection
      ::aBuffer[i]        := cBuffer
      ::aHBitmap[i]       := cHBitmap
      ::aImageMargin[i]   := cImgMargin
      ::aSubClass[i]      := cSubClass
*/
      oCtrl := ::oDesignForm:&ControlName:Object()
      IF ::aJustify[i] == "TOP"
         oCtrl:nAlign := 2
      ELSEIF ::aJustify[i] == "BOTTOM"
         oCtrl:nAlign := 3
      ELSEIF ::aJustify[i] == "LEFT"
         oCtrl:nAlign := 0
      ELSEIF ::aJustify[i] == "RIGHT"
         oCtrl:nAlign := 1
      ELSEIF ::aJustify[i] == "CENTER"
         oCtrl:nAlign := 4
      ELSE
         oCtrl:nAlign := 2
      ENDIF
      oCtrl:lThemed := ::aThemed[i]
      IF Len( ::aFontName[i] ) > 0
         oCtrl:FontName := ::aFontName[i]
      ENDIF
      IF ::aFontSize[i] > 0
         oCtrl:FontSize := ::aFontSize[i]
      ENDIF
      oCtrl:FontBold := ::aBold[i]
      oCtrl:FontItalic := ::aFontItalic[i]
      oCtrl:FontUnderline := ::aFontUnderline[i]
      oCtrl:FontStrikeout := ::aFontStrikeout[i]
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF
      oCtrl:ToolTip := ::aToolTip[i]
      oCtrl:TabStop := ! ::aNoTabStop[i]

   CASE nControlType == 3            // CHECKBOX
      @ _OOHG_MouseRow, _OOHG_MouseCol CHECKBOX &ControlName OF ( ::oDesignForm:Name ) ;
         CAPTION ControlName ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )
      oCtrl := ::oDesignForm:&ControlName:Object()
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 4            // LIST
      @ _OOHG_MouseRow, _OOHG_MouseCol LISTBOX &ControlName OF ( ::oDesignForm:Name ) ;
         ITEMS { ControlName } ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )

   CASE nControlType == 5            // COMBO
      @ _OOHG_MouseRow, _OOHG_MouseCol COMBOBOX &ControlName OF ( ::oDesignForm:Name ) ;
         ITEMS { ControlName, ' ' } ;
         VALUE 1 ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )

   CASE nControlType == 6            // CHECKBTN
      @ _OOHG_MouseRow, _OOHG_MouseCol CHECKBUTTON &ControlName OF ( ::oDesignForm:Name ) ;
         CAPTION ControlName ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name)

   CASE nControlType == 7            // GRID
      @ _OOHG_MouseRow, _OOHG_MouseCol GRID &ControlName OF ( ::oDesignForm:Name ) ;
         HEADERS { '', '' } ;
         WIDTHS { 100, 60 } ;
         ITEMS { { ControlName, '' } } ;
         TOOLTIP 'To access Properties and Events right click on header area.' ;
         ON CHANGE ::Dibuja( This:Name ) ;
         ON GOTFOCUS ::Dibuja( This:Name )

   CASE nControlType == 8            // FRAME
      IF ::aTransparent[::nControlW]
         @ _OOHG_MouseRow, _OOHG_MouseCol FRAME &ControlName OF ( ::oDesignForm:Name ) ;
            CAPTION ControlName ;
            TRANSPARENT
      ELSE
         @ _OOHG_MouseRow, _OOHG_MouseCol FRAME &ControlName OF ( ::oDesignForm:Name ) ;
            CAPTION ControlName
      ENDIF
      oCtrl := ::oDesignForm:&ControlName:Object()
     IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 9            // TAB
      ::swTab := .T.

      DEFINE TAB &ControlName OF ( ::oDesignForm:Name ) ;
         AT _OOHG_MouseRow, _OOHG_MouseCol ;
         WIDTH 300 ;
         HEIGHT 250 ;
         TOOLTIP ControlName ;
         ON CHANGE ::Dibuja( This:Name )
         DEFINE PAGE 'Page 1' IMAGE ''
         END PAGE
         DEFINE PAGE 'Page 2' IMAGE ''
         END PAGE
      END TAB

   CASE nControlType == 10           // IMAGE
      // TODO: use IMAGE control
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         WIDTH 100 ;
         HEIGHT 100 ;
         VALUE ControlName ;
         BORDER ;
         BACKCOLOR WHITE ;
         ACTION ::Dibuja( This:Name )

   CASE nControlType == 11           // ANIMATE
      // TODO: use ANIMATE control
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         WIDTH 100 ;
         HEIGHT 50 ;
         VALUE ControlName ;
         BORDER ;
         BACKCOLOR WHITE ;
         ACTION ::Dibuja( This:Name )

   CASE nControlType == 12           // DATEPICKER
      @ _OOHG_MouseRow, _OOHG_MouseCol DATEPICKER &ControlName OF ( ::oDesignForm:Name ) ;
         TOOLTIP ControlName ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )

   CASE nControlType == 13           // TEXT
      // TODO: add variable for WIDTH
      // TODO: use TEXTBOX control
      IF ::myIde:nTextBoxHeight > 0
         @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
            HEIGHT ::myIde:nTextBoxHeight ;
            VALUE ControlName ;
            CLIENTEDGE ;
            BACKCOLOR WHITE ;
            ACTION ::Dibuja( This:Name )
      ELSE
         @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
            VALUE ControlName ;
            CLIENTEDGE ;
            BACKCOLOR WHITE ;
            ACTION ::Dibuja( This:Name )
      ENDIF

   CASE nControlType == 14           // EDIT
      // TODO: use EDITBOX control
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         WIDTH 120 ;
         HEIGHT 120 ;
         VALUE ControlName ;
         CLIENTEDGE ;
         HSCROLL ;
         VSCROLL ;
         BACKCOLOR WHITE ;
         ACTION ::Dibuja( This:Name )

   CASE nControlType == 15           // LABEL
      // TODO:: add variable for WIDTH
      IF ::aTransparent[i]
         IF ::myIde:nLabelHeight > 0
            @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
               HEIGHT ::myIde:nLabelHeight ;
               VALUE ControlName ;
               TRANSPARENT ;
               ACTION ::Dibuja( This:Name )
         ELSE
            @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
               VALUE ControlName ;
               TRANSPARENT ;
               ACTION ::Dibuja( This:Name )
         ENDIF
      ELSE
         IF ::myIde:nLabelHeight > 0
            @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
               HEIGHT ::myIde:nLabelHeight ;
               VALUE ControlName ;
               ACTION ::Dibuja( This:Name )
         ELSE
            @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
               VALUE ControlName ;
               ACTION ::Dibuja( This:Name )
         ENDIF
      ENDIF

   CASE nControlType == 16           // PLAYER
      // TODO: use PLAYER control
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         WIDTH 100 ;
         HEIGHT 100 ;
         VALUE ControlName ;
         BORDER ;
         BACKCOLOR WHITE ;
         ACTION ::Dibuja( This:Name )

   CASE nControlType == 17           // PROGRESSBAR
      // TODO: use PROGRESSBAR control
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         WIDTH 120 ;
         HEIGHT 26 ;
         VALUE ControlName ;
         BORDER ;
         BACKCOLOR WHITE ;
         ACTION ::Dibuja( This:Name )

   CASE nControlType == 18           // RADIOGROUP
      // TODO: use RADIOGROUP control
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         WIDTH 100 ;
         HEIGHT ( 25 * 2 + 8 ) ;
         VALUE ControlName ;
         BORDER ;
         ACTION ::Dibuja( This:Name )
      oCtrl := ::oDesignForm:&ControlName:Object()
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ELSE
         oCtrl:BackColor := WHITE
      ENDIF

   CASE nControlType == 19           // SLIDER
      @ _OOHG_MouseRow, _OOHG_MouseCol SLIDER &ControlName OF ( ::oDesignForm:Name ) ;
         RANGE 1, 10 ;
         VALUE 5 ;
         ON CHANGE ::Dibuja( This:Name )
      oCtrl := ::oDesignForm:&ControlName:Object()
      IF IsValidArray( ::aBackColor[i] )
         oCtrl:BackColor := &( ::aBackColor[i] )
      ENDIF

   CASE nControlType == 20           // SPINNER
      // TODO: use SPINNER control
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         WIDTH 120 ;
         HEIGHT 24 ;
         VALUE ControlName ;
         CLIENTEDGE ;
         VSCROLL ;
         BACKCOLOR WHITE ;
         ACTION ::Dibuja( This:Name )

   CASE nControlType == 21           // PICCHECKBUTT
      @ _OOHG_MouseRow, _OOHG_MouseCol CHECKBUTTON &ControlName OF ( ::oDesignForm:Name ) ;
         PICTURE 'A4' ;
         WIDTH 30 ;
         HEIGHT 30 ;
         VALUE .F. ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )

   CASE nControlType == 22           // PICBUTT
      @ _OOHG_MouseRow, _OOHG_MouseCol BUTTON &ControlName OF ( ::oDesignForm:Name ) ;
         PICTURE 'A4' ;
         WIDTH 30 ;
         HEIGHT 30 ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ACTION ::Dibuja( This:Name )

   CASE nControlType == 23           // TIMER
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         WIDTH 100 ;
         HEIGHT 20 ;
         VALUE ControlName ;
         BORDER ;
         BACKCOLOR WHITE ;
         ACTION ::Dibuja( This:Name )

   CASE nControlType == 24           // BROWSE
      @ _OOHG_MouseRow, _OOHG_MouseCol GRID &ControlName OF ( ::oDesignForm:Name ) ;
         HEADERS { 'one', 'two' } ;
         WIDTHS { 60, 60 } ;
         ITEMS { { ControlName, '' } } ;
         TOOLTIP 'Click on header area to move/size' ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )

   CASE nControlType == 25           // TREE
      DEFINE TREE &ControlName OF ( ::oDesignForm:Name ) ;
         AT _OOHG_MouseRow, _OOHG_MouseCol ;
         WIDTH 100 ;
         HEIGHT 100 ;
         VALUE 1 ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )

         NODE 'Tree'
         END NODE
         NODE 'Nodes'
         END NODE
      END TREE

   CASE nControlType == 26           // IPADDRESS
      // TODO: use IPADDRESS control
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         VALUE '   .   .   .   ' ;
         CLIENTEDGE ;
         BACKCOLOR WHITE ;
         ACTION ::Dibuja( This:Name )

   CASE nControlType == 27           // MONTHCALENDAR
      @ _OOHG_MouseRow, _OOHG_MouseCol MONTHCALENDAR &ControlName OF ( ::oDesignForm:Name ) ;
         ON CHANGE ::Dibuja( This:Name )

   CASE nControlType == 28           // HYPERLINK
      // TODO: use IPADDRESS control
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         VALUE ControlName ;
         ACTION ::Dibuja( This:Name ) ;
         BACKCOLOR WHITE ;
         BORDER

   CASE nControlType == 29           // RICHEDIT
      // TODO: use RICHEDIT control
      @ _OOHG_MouseRow, _OOHG_MouseCol LABEL &ControlName OF ( ::oDesignForm:Name ) ;
         WIDTH 120 ;
         HEIGHT 124 ;
         VALUE ControlName ;
         CLIENTEDGE ;
         BACKCOLOR WHITE ;
         ACTION ::Dibuja( This:Name )

   CASE nControlType == 30           // TIMEPICKER
      @ _OOHG_MouseRow, _OOHG_MouseCol TIMEPICKER &ControlName OF ( ::oDesignForm:Name ) ;
         TOOLTIP ControlName ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )

   CASE nControlType == 31           // XBROWSE
      @ _OOHG_MouseRow, _OOHG_MouseCol GRID &ControlName OF ( ::oDesignForm:Name ) ;
         HEADERS { 'one', 'two' } ;
         WIDTHS { 60, 60 } ;
         ITEMS { { ControlName, '' } } ;
         TOOLTIP 'Click on header area to move/size' ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )

   ENDCASE
RETURN ::oDesignForm:&ControlName:Object

//------------------------------------------------------------------------------
METHOD Dibuja( xName, lNoRefresh, lNoErase ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL h, l, oControl, nRow, nCol, nWidth, nHeight, cLabel, y, x, y1, x1

   IF ::lAddingNewControl
      RETURN NIL
   ENDIF

   h := aScan( ::oDesignForm:aControls, { |o| Lower( o:Name ) == Lower( xName ) } )
   DEFAULT lNoRefresh TO .F.
   DEFAULT lNoErase   TO .F.
   IF ! lNoErase
      EraseWindow( ::oDesignForm:Name )
      ::MisPuntos()
   ENDIF
   oControl := ::oDesignForm:aControls[h]
   y :=  oControl:ContainerRow
   x :=  oControl:ContainerCol
   y1:=  oControl:ContainerRow + oControl:Height
   x1:=  oControl:ContainerCol + oControl:Width

   DRAW RECTANGLE IN WINDOW ( ::oDesignForm:Name ) ;
      AT oControl:ContainerRow - 10, oControl:ContainerCol - 10 ;
      TO oControl:ContainerRow, oControl:ContainerCol ;
      PENCOLOR { 255, 0, 0 } ;
      FILLCOLOR { 255, 0, 0 }

   DRAW RECTANGLE IN WINDOW ( ::oDesignForm:Name ) ;
      AT oControl:ContainerRow + oControl:Height + 1, oControl:ContainerCol + oControl:Width + 1 ;
      TO oControl:ContainerRow + oControl:Height + 6, oControl:ContainerCol + oControl:Width + 6 ;
      PENCOLOR { 255, 0, 0 } ;
      FILLCOLOR { 255, 0, 0 }

   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) ;
      AT y - 1, x - 1 ;
      TO y - 1 + oControl:Height + 1, x - 1 ;
      PENCOLOR { 255, 0, 0 }

   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) ;
      AT y - 1, x - 1 ;
      TO y - 1, x - 1 + oControl:Width + 1 ;
      PENCOLOR { 255, 0, 0 }

   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) ;
      AT y - 1 + oControl:Height + 1, x - 1 ;
      TO y1, x1 + 1 ;
      PENCOLOR { 255, 0, 0 }

   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) ;
      AT y - 1, x - 1 + oControl:Width + 1 ;
      TO y1 + 1, x1 ;
      PENCOLOR { 255, 0, 0 }

   l := aScan( ::aControlW, { |c| Lower( c ) == Lower( oControl:Name ) } )

   IF l > 0
      ::Form_Main:frame_2:Caption := "Control : "+  ::aName[l]
      ::Form_Main:frame_2:Refresh()

      nRow    := oControl:Row
      nCol    := oControl:Col
      nWidth  := oControl:Width
      nHeight := oControl:Height
      cLabel  := " r:" + Alltrim( Str( nRow, 4 ) ) + " c:" + AllTrim( Str( nCol, 4 ) ) + " w:" + AllTrim( Str( nWidth, 4 ) ) + " h:" + AllTrim( Str( nHeight, 4 ) )
      ::Form_Main:label_2:Value := cLabel

      ::nHandleP := h
      IF ! lNoRefresh
         ::RefreshControlInspector( oControl:Name )
      ENDIF
   ELSE
      ::nHandleP := 0
      ::myHandle := 0
      ::Form_Main:label_2:Value:= ' r:    c:    w:    h: '
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Edit_Properties( aParams ) CLASS TFormEditor
//------------------------------------------------------------------------------
   IF aParams[1] > 0
      ::Dibuja( ::oCtrlList:Cell( aParams[1], 6 ) )
      ::Properties_Click()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ManualMoSI( nOption ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oControl, jk, cName, nRow, nCol, nWidth, nHeight, cTitle, aLabels, aInitValues, aFormats, aResults, lChanged

   IF ::nControlW == 1
      RETURN NIL
   ENDIF
   lChanged := .F.
   IF nOption == 1
      IF ::nHandleP > 0
         oControl := ::oDesignForm:aControls[::nHandleP]
         jk := aScan( ::aControlW, { |c| Lower( c ) == Lower( oControl:Name ) } )

         cName   := ::aControlW[jk]
         nRow    := ::oDesignForm:&cName:Row
         nCol    := ::oDesignForm:&cName:Col
         nWidth  := ::oDesignForm:&cName:Width
         nHeight := ::oDesignForm:&cName:Height
         cTitle  := cName + " Move/Size properties"

         IF ::SiEsDEste( ::nHandleP, 'RADIOGROUP' )
            aLabels     := { 'Row', 'Col', 'Width' }
            aInitValues := { nRow, nCol, nWidth }
            aFormats    := { '9999', '9999', '9999' }
            aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
            IF aResults[1] == NIL
               RETURN NIL
            ENDIF
            IF aResults[1] >= 0
               lChanged := .T.
               ::oDesignForm:&cName:Row := aResults[1]
            ENDIF
            IF aResults[2] >= 0
               lChanged := .T.
               ::oDesignForm:&cName:Col := aResults[2]
            ENDIF
            IF aResults[3] >= 0
               lChanged := .T.
               ::oDesignForm:&cName:Width := aResults[3]
            ENDIF
         ELSE
            aLabels     := { 'Row', 'Col', 'Width', 'Height' }
            aInitValues := { nRow, nCol, nWidth, nHeight }
            aFormats    := { '9999', '9999', '9999', '9999' }
            aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
            IF aResults[1] == NIL
               RETURN NIL
            ENDIF
            IF aResults[1] >= 0
               lChanged := .T.
               ::oDesignForm:&cName:Row := aResults[1]
            ENDIF
            IF aResults[2] >= 0
               lChanged := .T.
               ::oDesignForm:&cName:Col := aResults[2]
            ENDIF
            IF ! ::SiEsDEste( ::nHandleP, 'MONTHCALENDAR' ) .AND. ! ::SiEsDEste( ::nHandleP, 'TIMER' )
               IF aResults[3] >= 0
                  lChanged := .T.
                  ::oDesignForm:&cName:Width  := aResults[3]
               ENDIF
               IF aResults[4] >= 0
                  lChanged := .T.
                  ::oDesignForm:&cName:Height := aResults[4]
               ENDIF
            ENDIF
         ENDIF
         IF lChanged
            ::Snap( cName )
            ::Dibuja( cName )
            ::lFSave := .F.
         ENDIF
      ENDIF
   ELSE
      nRow    := ::oDesignForm:Row
      nCol    := ::oDesignForm:Col
      nWidth  := ::oDesignForm:Width
      nHeight := ::oDesignForm:Height
      cTitle  := " Form Move/Size properties"

      aLabels     := { 'Row', 'Col', 'Width', 'Height' }
      aInitValues := { nRow, nCol, nWidth, nHeight }
      aFormats    := { '9999', '9999', '9999', '9999' }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      IF aResults[1] >= 0
         lChanged := .T.
         ::oDesignForm:Row := aResults[1]
      ENDIF
      IF aResults[2] >= 0
         lChanged := .T.
         ::oDesignForm:Col := aResults[2]
      ENDIF
      IF aResults[3] >= 0
         lChanged := .T.
         ::oDesignForm:Width := aResults[3]
      ENDIF
      IF aResults[4] >= 0
         lChanged := .T.
         ::oDesignForm:Height := aResults[4]
      ENDIF
      IF lChanged
         ::lFSave := .F.
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD KMove() CLASS TFormEditor
//------------------------------------------------------------------------------
   IF ::nHandleP == 0
      MsgStop( "You must select a control first.", "OOHG IDE+" )
      RETURN NIL
   ENDIF
   IF ::nControlW == 1
      RETURN NIL
   ENDIF

   ON KEY LEFT       OF ( ::oDesignForm:Name ) ACTION ::KMueve( "L" )
   ON KEY RIGHT      OF ( ::oDesignForm:Name ) ACTION ::KMueve( "R" )
   ON KEY UP         OF ( ::oDesignForm:Name ) ACTION ::KMueve( "U" )
   ON KEY DOWN       OF ( ::oDesignForm:Name ) ACTION ::KMueve( "D" )
   ON KEY ESCAPE     OF ( ::oDesignForm:Name ) ACTION ::KMueve( "E" )
	ON KEY CTRL+LEFT  OF ( ::oDesignForm:Name ) ACTION ::KMueve( "W-" )
   ON KEY CTRL+RIGHT OF ( ::oDesignForm:Name ) ACTION ::KMueve( "W+" )
   ON KEY CTRL+UP    OF ( ::oDesignForm:Name ) ACTION ::KMueve( "H-" )
   ON KEY CTRL+DOWN  OF ( ::oDesignForm:Name ) ACTION ::KMueve( "H+" )

   IF _IsControlDefined( "Statusbar", ::oDesignForm:Name )
      ::oDesignForm:Statusbar:Release()
   ENDIF
   DEFINE STATUSBAR OF ( ::oDesignForm:Name )
      STATUSITEM ""
   END STATUSBAR
   ::KMueve( "" )
RETURN NIL

//------------------------------------------------------------------------------
METHOD KMueve( cPar ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nR, nC, oControl, cName, h

   IF ::nHandleP == 0
      RETURN NIL
   ENDIF
   oControl := ::oDesignForm:aControls[::nHandleP]
   cName := oControl:Name
//   ::Dibuja( cName )
   h := ::oDesignForm:hWnd
   nR := oControl:Row + GetWindowRow( h ) + GetTitleHeight() + ( GetBorderHeight() * 2 ) + 18
   nC := oControl:Col + GetWindowCol( h ) + GetBorderWidth() + ( oControl:Width / 2 )
   SetCursorPos( nC , nR )

   IF cPar == "E"
      RELEASE KEY LEFT   OF ( ::oDesignForm:Name )
      RELEASE KEY RIGHT  OF ( ::oDesignForm:Name )
      RELEASE KEY UP     OF ( ::oDesignForm:Name )
      RELEASE KEY DOWN   OF ( ::oDesignForm:Name )
      RELEASE KEY ESCAPE OF ( ::oDesignForm:Name )
      ::oDesignForm:StatusBar:Release()
      IF ::lSStat
         ::CreateStatusBar()
      ENDIF
      ::Snap( cName )
   ELSE
      DO CASE
      CASE cPar == "L"
         ::oDesignForm:&cName:Col := ::oDesignForm:&cName:Col - IIF( ::myIde:lSnap, ::myIde:nPxMove, 1 )
         ::lFSave := .F.
      CASE cPar == "R"
         ::oDesignForm:&cName:Col := ::oDesignForm:&cName:Col + IIF( ::myIde:lSnap, ::myIde:nPxMove, 1 )
         ::lFSave := .F.
      CASE cPar == "U"
         ::oDesignForm:&cName:Row := ::oDesignForm:&cName:Row - IIF( ::myIde:lSnap, ::myIde:nPxMove, 1 )
         ::lFSave := .F.
      CASE cPar == "D"
         ::oDesignForm:&cName:Row := ::oDesignForm:&cName:Row + IIF( ::myIde:lSnap, ::myIde:nPxMove, 1 )
         ::lFSave := .F.
      CASE cPar == "W-"
         ::oDesignForm:&cName:Width := ::oDesignForm:&cName:Width - IIF( ::myIde:lSnap, ::myIde:nPxSize, 1 )
         ::lFSave := .F.
      CASE cPar == "W+"
         ::oDesignForm:&cName:Width := ::oDesignForm:&cName:Row + IIF( ::myIde:lSnap, ::myIde:nPxSize, 1 )
         ::lFSave := .F.
      CASE cPar == "H-"
         ::oDesignForm:&cName:Height := ::oDesignForm:&cName:Row - IIF( ::myIde:lSnap, ::myIde:nPxSize, 1 )
         ::lFSave := .F.
      CASE cPar == "H+"
         ::oDesignForm:&cName:Height := ::oDesignForm:&cName:Row + IIF( ::myIde:lSnap, ::myIde:nPxSize, 1 )
         ::lFSave := .F.
      ENDCASE
      ::oDesignForm:StatusBar:Item( 1, " Row = " + Str( ::oDesignForm:&cName:Row, 4 ) + "  Col = " + Str( ::oDesignForm:&cName:Col, 4 ) + "  Use Arrow Keys to Move and [Esc] To Exit Keyboard Move" )
   ENDIF
   ::Dibuja( cName )
RETURN NIL

//------------------------------------------------------------------------------
METHOD MoveControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oControl, nRowAnterior, nColAnterior, nRowActual, nColActual

   IF ::nHandleP > 0
      oControl := ::oDesignForm:aControls[::nHandleP]
      nRowAnterior := GetWindowRow( oControl:hWnd )
      ncolAnterior := GetWindowCol( oControl:hWnd )
      EraseWindow( ::oDesignForm:Name )
      ::MisPuntos()
      InteractiveMoveHandle( oControl:hWnd )
      CHideControl( oControl:hWnd )
      nRowActual   := GetWindowRow( oControl:hWnd )
      nColActual   := GetWindowcol( oControl:hWnd )
      oControl:Row := oControl:Row + ( nRowActual - nRowAnterior )
      oControl:col := oControl:col + ( nColActual - nColAnterior )
      ::Snap( oControl:Name )
      CShowControl( oControl:hWnd )
      IF oControl:Type == 'TAB'
         ::oDesignForm:Hide()
         ::oDesignForm:Show()
      ENDIF
      ::Dibuja( oControl:Name )
      ::lFSave := .F.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD SizeControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oControl, cName, nnheight

   if ::nHandleP > 0
      if ::SiEsDEste( ::nHandleP, 'MONTHCALENDAR' ) .OR. ::SiEsDEste( ::nHandleP, 'TIMER' ) .or. ::SiEsDEste( ::nHandleP, 'COMBO' )
         RETURN NIL
      endif
      ocontrol:=::oDesignForm:acontrols[::nHandleP]
      cName := ocontrol:name
      nnheight := ocontrol:height
      if ! ::SiEsDEste( ::nHandleP, 'COMBO' )
         interactivesizehandle( ocontrol:hWnd)
      endif
      ///CHideControl (ocontrol:hWnd)
      ::lfsave:=.F.
      ////CShowControl (ocontrol:hWnd)
      if ::SiEsDEste( ::nHandleP, 'RADIOGROUP' )
         ocontrol:width := GetWindowWidth ( ocontrol:hWnd )
         ::oDesignForm:&cname:height := nnheight
      else
         ocontrol:Width := GetWindowWidth ( ocontrol:hWnd )
         ocontrol:Height := GetWindowHeight ( ocontrol:hWnd )
      endif
      ::Dibuja( cName )
   endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD GlobalVertGapChg() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL aItemsSel, aInput, aControls, i, nFila, cName, oCtrl, nNewRowPos
LOCAL nNewColPos, nActualCtrlHeight

   aControls := {}
   aItemsSel := ::oCtrlList:Value

   IF Len( aItemsSel ) > 1
      CursorWait()

      ::oDesignForm:SetRedraw( .F. )
      ::oCtrlList:SetRedraw( .F. )
      FOR i := 1 TO Len( aItemsSel )
         nFila := aItemsSel[i]
         cName := ::oCtrlList:Cell( nFila, 6 )
         oCtrl := ::oDesignForm:&cName:Object()
         aAdd( aControls, { cName, oCtrl:Row, cName } )
      NEXT
      aSort( aControls, , , { |x, y| x[2] < y[2] } )
      cName      := aControls[1, 1]
      oCtrl      := ::oDesignForm:&cName:Object()
      nNewRowPos := oCtrl:Row
      nNewColPos := oCtrl:Col
      aInput     := ::myIde:myInputWindow( 'Global Vert Gap Change', { 'New Gap Value', 'New Col Value' }, { ::myIde:nStdVertGap, nNewColPos }, { '9999', '9999' } )

      FOR i := 1 TO Len( aControls )
         cName             := aControls[i, 1]
         oCtrl             := ::oDesignForm:&cName:Object()
         nActualCtrlHeight := oCtrl:Height
         oCtrl:Row         := nNewRowPos
         IF aInput[2] # 0
            oCtrl:Col := aInput[2]
         ENDIF
         ::ProcesaControl( oCtrl )
         nNewRowPos := nNewRowPos + aInput[1] + nActualCtrlHeight
      NEXT

      ::oCtrlList:SetRedraw( .T. )
      ::oCtrlList:Redraw()
      ::oDesignForm:SetRedraw( .T. )
      ::oDesignForm:Redraw()

      CursorArrow()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ValCellPos() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL wValue, cName, oCtrl

   wValue := This.CellRowIndex
   cName  := ::oCtrlList:Cell( wValue, 6 )
   oCtrl  := ::oDesignForm:&cName:Object()

   DO CASE
   CASE This.CellColIndex == 2
      oCtrl:Row := Val( ::oCtrlList:Cell( wValue, 2 ) )
   CASE This.CellColIndex == 3
      oCtrl:Col := Val( ::oCtrlList:Cell( wValue, 3 ) )
   CASE This.CellColIndex == 4
      oCtrl:Width := Val( ::oCtrlList:Cell( wValue, 4 ) )
   CASE This.CellColIndex == 5
      oCtrl:Height := Val( ::oCtrlList:Cell( wValue, 5 ) )
   ENDCASE

   ::ProcesaControl( oCtrl )
RETURN NIL

//------------------------------------------------------------------------------
METHOD ValGlobalPos( cCual ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL aItemsSel, aInput, nActRow, nActCol, nActWid, nActHei, i, nFila, cName
LOCAL oCtrl, nHShift, nVShift, nLen

   aItemsSel := ::oCtrlList:Value
   nLen := Len( aItemsSel )

   IF nLen > 0
      DO CASE
      CASE cCual == 'ROW'
         nActRow := Val( ::oCtrlList:Cell( aItemsSel[1], 2 ) )
         aInput  := ::myIde:myInputWindow( 'Global Row Change', { 'New Row Value' }, { nActRow }, { '9999' } )
      CASE cCual == 'COL'
         nActCol := Val( ::oCtrlList:Cell( aItemsSel[1], 3 ) )
         aInput  := ::myIde:myInputWindow( 'Global Col Change', { 'New Col Value' }, { nActCol }, { '9999' } )
      CASE cCual == 'WID'
         nActWid := Val( ::oCtrlList:Cell( aItemsSel[1], 4 ) )
         aInput  := ::myIde:myInputWindow( 'Global Width Change', { 'New Width Value' }, { nActWid }, { '9999' } )
      CASE cCual == 'HEI'
         nActHei := Val( ::oCtrlList:Cell( aItemsSel[1], 5 ) )
         aInput  := ::myIde:myInputWindow( 'Global Height Change', { 'New Height Value'}, { nActHei }, { '9999' } )
      CASE cCual == 'SHI'
         nHShift := 0
         nVShift := 0
         aInput  := ::myIde:myInputWindow( 'Global Shift', { 'Horizontal Value', 'Vertical Value '}, { nHShift, nVShift }, { '9999', '9999' } )
      ENDCASE

      IF aInput[1] == NIL
         RETURN NIL
      ENDIF

      CursorWait()

      ::oDesignForm:SetRedraw( .F. )
      ::oCtrlList:SetRedraw( .F. )

      FOR i := 1 TO Len( aItemsSel )
         nFila := aItemsSel[i]
         cName := ::oCtrlList:Cell( nFila, 6 )
         oCtrl := ::oDesignForm:&cName:Object()

         DO CASE
         CASE cCual == 'ROW'
              oCtrl:Row    := aInput[1]
         CASE cCual == 'COL'
              oCtrl:Col    := aInput[1]
         CASE cCual == 'WID'
              oCtrl:Width  := aInput[1]
         CASE cCual == 'HEI'
              oCtrl:Height := aInput[1]
         CASE cCual == 'SHI'
              oCtrl:Col    := oCtrl:Col + aInput[1]
              oCtrl:Row    := oCtrl:Row + aInput[2]
         ENDCASE

         ::ProcesaControl( oCtrl )
      NEXT

      EraseWindow( ::oDesignForm:Name )
      FOR i := 1 TO nLen
         ::Dibuja( ::oCtrlList:Cell( aItemsSel[i], 6 ), .T., .F. )
      NEXT i
      ::MisPuntos()
      ::RefreshControlInspector()

      ::oCtrlList:SetRedraw( .T. )
      ::oCtrlList:Redraw()
      ::oDesignForm:SetRedraw( .T. )
      ::oDesignForm:Redraw()

      CursorArrow()
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD PrintBrief() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL aInput, aItems, i, nRow, nCol, nHeight, nWidth, uValue
LOCAL cName, oCtrl, cRealName, cType, oPrint, ContLin, wpage, lDynamicOnly
LOCAL aOptions := { 'Tab Order', 'Name', 'Type', 'Row', 'Col' }
LOCAL aOptionsN := { 0, 1, 7, 2, 3 }
LOCAL nIndice, cObj, nCantItems

   aItems := {}
   aInput := ::myIde:myInputWindow( 'Print Brief', { 'Filter Dynamic Controls','Print Events', 'Sort By', 'Draw Grid' }, { .T., .T., 1, .F. }, { NIL, NIL, aOptions, NIL } )
   CursorWait()

   DEFAULT aInput[3] TO 1
   lDynamicOnly := aInput[1]

   nCantItems := ::oCtrlList:ItemCount
   FOR i := 1 TO nCantItems
      aAdd( aItems, { ::oCtrlList:cell( i, 1 ), ::oCtrlList:cell( i, 2 ), ::oCtrlList:cell( i, 3), ::oCtrlList:cell( i, 4), ::oCtrlList:cell( i, 5), ::oCtrlList:cell( i, 6 ), ::oCtrlList:cell( i, 7 ) } )
   NEXT
   nIndice := aOptionsN[aInput[3]]
   IF nIndice > 0
      IF nIndice # 2
         aSort( aItems, NIL, NIL, { |x, y| x[nIndice] < y[nIndice] } )
      ELSE
         aSort( aItems, NIL, NIL, { |x, y| x[2] + x[3] < y[2] + y[3] } )
      ENDIF
   ENDIF

   oPrint := TPrint( "HBPRINTER" )
   oPrint:Init()
   oPrint:SelPrinter( .T., .T., .T. )
   IF oPrint:lPrError
      MsgStop( 'Error detected while printing.', 'ooHG IDE+' )
      oPrint:Release()
      RETURN NIL
   ENDIF
   oPrint:Begindoc()
   oPrint:SetFont( NIL, NIL, NIL, .T. )
   oPrint:SetPreviewSize( 2 )
   oPrint:BeginPage()
   oPrint:SetCPL( 120 )

   ContLin := 1
   wpage   := 1
   oPrint:PrintData( ContLin, 0, 'BRIEF OF ' + IIF( lDynamicOnly, 'DYNAMIC', 'ALL' ) + ' CONTROLS IN FORM: ' + ::oDesignForm:Title + ' OBJ: ' + ::cFObj )
   oPrint:PrintData( ContLin, 143, 'SORTED BY ' + Upper( aOptions[aInput[3]] ) )
   ContLin ++
   oPrint:PrintData( ContLin, 0, 'FILE: ' + ::cForm )
   oPrint:PrintData( ContLin, 143, Dtoc( Date() ) + ' ' + Time() )
   ContLin ++
   oPrint:PrintData( ContLin, 0, Replicate( '-', 162 ) )
   ContLin ++
   oPrint:PrintData( Contlin, 0, 'NAME                    TYPE        ROW    COL   WIDTH HEIGHT  VALUE                 OBJ                  NUM  DATE  RONLY  UPPER  RALIGN  MAXLEN  IMASK           ' )
   /*
   oPrint:Printdata( Contlin, 0, '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012' )
   ContLin ++
   oPrint:Printdata( Contlin, 0, '0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6  ' )
   ContLin ++
   */
   ContLin ++
   oPrint:PrintData( ContLin, 0, Replicate( '-', 162 ) )
   IF aInput[4]
      ContLin ++
   ENDIF
   FOR i := 1 TO nCantItems
      cRealName := aItems[i, 1]
      cName     := aItems[i, 6]
      cType     := aItems[i, 7]
      oCtrl     := ::oDesignForm:&cName:Object()
      nRow      := oCtrl:Row
      nCol      := oCtrl:Col
      nWidth    := oCtrl:Width
      nHeight   := oCtrl:Height
      uValue    := oCtrl:Value
      nIndice   := aScan( ::aControlW, { |c| Lower( c ) == Lower( cName ) } )
      cObj      := ::aCObj[nIndice]

      IF Upper( cType ) $ "LABEL FRAME TIMER IMAGE" .AND. lDynamicOnly
      ELSE
         IF ! aInput[4]
            ContLin ++
         ENDIF
         oPrint:PrintData( ContLin, 000, Left( cRealName, 23 ) )
         oPrint:PrintData( ContLin, 024, Left( cType, 11 ) )
         oPrint:PrintData( ContLin, 036, StrZero( nRow, 3 ) )
         oPrint:PrintData( ContLin, 043, StrZero( nCol, 3 ) )
         oPrint:PrintData( ContLin, 050, StrZero( nWidth, 3 ) )
         oPrint:PrintData( ContLin, 056, StrZero( nHeight, 3 ) )
         oPrint:PrintData( ContLin, 063, Left( CStr( uValue ), 20 ) )
         oPrint:PrintData( ContLin, 085, Left( CStr( cObj ), 20 ) )
         oPrint:PrintData( ContLin, 108, IIF( ::aNumeric[nIndice], 'Y', 'N' ) )
         oPrint:PrintData( ContLin, 113, IIF( ::aDate[nIndice], 'Y', 'N' ) )
         oPrint:PrintData( ContLin, 120, IIF( ::aReadOnly[nIndice], 'Y', 'N' ) )
         oPrint:PrintData( ContLin, 127, IIF( ::aUpperCase[nIndice], 'Y', 'N' ) )
         oPrint:PrintData( ContLin, 134, IIF( ::aRightAlign[nIndice], 'Y', 'N' ) )
         oPrint:PrintData( ContLin, 142, Transform( ::aMaxLength[nIndice], '999' ) )
         oPrint:PrintData( ContLin, 148, AllTrim( ::aInputMask[nIndice] ) )
         IF ! Empty( ::aField[nIndice] )
            oPrint:PrintData( ++ ContLin, 005, 'FIELD      : ' + AllTrim( ::aField[nIndice] ) )
         ENDIF
         IF ! Empty( ::aValid[nIndice] )
            oPrint:PrintData( ++ ContLin, 005, 'VALID      : ' + AllTrim( ::aValid[nIndice] ) )
         ENDIF
         IF ! Empty( ::aWhen[nIndice] )
            oPrint:PrintData( ++ Contlin, 005, 'WHEN       : ' + AllTrim( ::aWhen[nIndice] ) )
         ENDIF
         IF ContLin > 40
            ContLin ++
            oPrint:PrintData( ++ ContLin, 0, 'Page... ' + Ltrim( Str( wpage, 3 ) ) )
            oPrint:PrintData( ++ ContLin, 0,  Replicate( '-', 162 ) )
            oPrint:EndPage()
            oPrint:BeginPage()
            ContLin := 1
            wpage ++
         ENDIF
         IF aInput[2]
            IF ! Empty( ::aAction[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ACTION     : ' + AllTrim( CStr( ::aAction[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aAction2[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ACTION2    : ' + AllTrim( CStr( ::aAction2[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnDblClick[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONDBLCLICK : ' + AllTrim( CStr( ::aOnDblClick[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnChange[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONCHANGE   : ' + AllTrim( CStr( ::aOnChange[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnGotFocus[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONGOTFOCUS : ' + AllTrim( CStr( ::aOnGotFocus[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnLostFocus[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONLOSTFOCUS: ' + AllTrim( CStr( ::aOnLostFocus[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aonenter[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONENTER    : ' + AllTrim( CStr( ::aonenter[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnDisplayChange[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONDISP.CHG.: ' + AllTrim( CStr( ::aOnDisplayChange[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnHeadClick[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONHEADCLICK: ' + AllTrim( CStr( ::aOnHeadClick[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnEditCell[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONEDITCELL : ' + AllTrim( CStr( ::aOnEditCell[nIndice] ) ) )
            ENDIF
            IF ! Empty( ::aOnAppend[nIndice] )
               oPrint:PrintData( ++ ContLin, 005, 'ONAPPEND   : ' + AllTrim( CStr( ::aOnAppend[nIndice] ) ) )
            ENDIF
         ENDIF
         IF aInput[4]
            oPrint:PrintLine( ++ Contlin, 0, ContLin, 162 )
         ENDIF
      ENDIF
   NEXT

   ContLin ++
   oPrint:PrintData( ++ ContLin, 0, 'Page... ' + LTrim( Str( wpage, 3 ) ) )
   oPrint:PrintData( ++ ContLin, 0, Replicate( '-', 162 ) )
   oPrint:PrintData( ++ ContLin, 0, 'End print' )
   oPrint:EndPage()
   oPrint:EndDoc()
   CursorArrow()
RETURN NIL

//------------------------------------------------------------------------------
METHOD ShowFormData() CLASS TFormEditor
//------------------------------------------------------------------------------
   ::Form_Main:label_1:Value := " r:" + AllTrim( Str( ::oDesignForm:Row, 4 ) ) + ;
                                " c:" + AllTrim( Str( ::oDesignForm:Col, 4 ) ) + ;
                                " w:" + AllTrim( Str( ::oDesignForm:Width, 4 ) ) + ;
                                " h:" + Alltrim( Str( ::oDesignForm:Height, 4 ) )
   ::MisPuntos()
RETURN NIL

//------------------------------------------------------------------------------
METHOD SelectControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nFocus, aVal, nLen, i, lNoErase

   nFocus := GetFocus()
   IF nFocus > 0
      IF nFocus == ::oCtrlList:hWnd
         EraseWindow( ::oDesignForm:Name )
         aVal := ::oCtrlList:Value
         IF ( nLen := Len( aVal ) ) > 0
            lNoErase := ( nLen > 1 )
            FOR i := 1 TO nLen
               ::Dibuja( ::oCtrlList:Cell( aVal[i], 6 ), .T., lNoErase )
            NEXT i
         ENDIF
         ::MisPuntos()
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD FillControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, lItem, cTipo, cLine, nAt, nWidth, cAction, cIcon, lFlat, lRaised, lAmPm
LOCAL cToolTip, lCenter, lLeft, lRight, cCaption, nProcess

   ::swTab := .F.

   // Load Statusbar data
   FOR i := 1 TO Len( ::aLine )
      IF At( 'DEFINE STATUSBAR', Upper( ::aLine[i] ) ) # 0
         ::lSStat := .T.
         ::Form_Main:butt_status:Value := .T.
         ::cvcControls:Control_Stabusbar:Visible := .T.

         ::cSCObj         := ::LeaDato( 'DEFINE STATUSBAR', 'OBJ', '' )
         ::lSTop          := ( ::LeaDatoLogic( 'DEFINE STATUSBAR', 'TOP', "F" ) == "T" )
         ::lSNoAutoAdjust := ( ::LeaDatoLogic( 'DEFINE STATUSBAR', 'NOAUTOADJUST', "F" ) == "T" )
         ::cSSubClass     := ::LeaDato( 'DEFINE STATUSBAR', 'SUBCLASS', '' )
         ::cSFontName     := ::Clean( ::LeaDato( 'DEFINE STATUSBAR', 'FONT', '' ) )
         ::nSFontSize     := Val( ::LeaDato( 'DEFINE STATUSBAR', 'SIZE', '0' ) )
         ::lSBold         := ( ::LeaDatoLogic( 'DEFINE STATUSBAR', 'BOLD', 'F' ) == "T" )
         ::lSItalic       := ( ::LeaDatoLogic( 'DEFINE STATUSBAR', 'ITALIC', 'F' ) == "T" )
         ::lSUnderline    := ( ::LeaDatoLogic( 'DEFINE STATUSBAR', 'UNDERLINE', 'F' ) == "T" )
         ::lSStrikeout    := ( ::LeaDatoLogic( 'DEFINE STATUSBAR', 'STRIKEOUT', 'F' ) == "T" )
         lItem            := .F.
         ::cSCaption      := "{ "
         ::cSWidth        := "{ "
         ::cSAction       := "{ "
         ::cSIcon         := "{ "
         ::cSStyle        := "{ "
         ::cSToolTip      := "{ "
         ::cSAlign        := "{ "
         ::lSKeyboard     := .F.
         ::nSKWidth       := 0
         ::cSKAction      := ''
         ::cSKToolTip     := ''
         ::cSKImage       := ''
         ::cSKStyle       := ''
         ::cSKAlign       := ''
         ::lSDate         := .F.
         ::nSDWidth       := 0
         ::cSDAction      := ''
         ::cSDToolTip     := ''
         ::cSDStyle       := ''
         ::cSDAlign       := ''
         ::lSTime         := .F.
         ::nSCWidth       := 0
         ::cSCAction      := ''
         ::cSCToolTip     := ''
         ::lSCAmPm        := .F.
         ::cSCImage       := ''
         ::cSCStyle       := ''
         ::cSCAlign       := ''

         i ++
         DO WHILE i <= Len( ::aLine )
            cLine := Upper( ::aLine[i] )
            IF At( 'END STATUSBAR', cLine ) # 0
               EXIT
            ENDIF

            IF ( nAt := At( 'STATUSITEM ', cLine ) ) # 0
               lItem := .T.
               nProcess := 1
               cCaption := RTrim( SubStr( ::aLine[i], nAt + 11 ) )
            ELSEIF ( nAt := At( 'KEYBOARD ', cLine ) ) # 0 .AND. ! ::lSKeyboard
               ::lSKeyboard := .T.
               nProcess := 2
               cCaption := RTrim( SubStr( ::aLine[i], nAt + 9 ) )
            ELSEIF ( nAt := At( 'DATE ', cLine ) ) # 0 .AND. ! ::lSDate
               ::lSDate := .T.
               nProcess := 3
               cCaption := RTrim( SubStr( ::aLine[i], nAt + 5 ) )
            ELSEIF ( nAt := At( 'CLOCK ', cLine ) ) # 0 .AND. ! ::lSTime
               ::lSTime := .T.
               nProcess := 4
               cCaption := RTrim( SubStr( ::aLine[i], nAt + 6 ) )
            ELSE
               nProcess := 0
            ENDIF

            IF nProcess > 0
               nWidth   := 0
               cAction  := ''
               cIcon    := ''
               lFlat    := .F.
               lRaised  := .F.
               cToolTip := ''
               lCenter  := .F.
               lLeft    := .F.
               lRight   := .F.
               lAmPm    := .F.

               IF Right( cCaption, 1 ) == ";"
                  cCaption := AllTrim( SubStr( cCaption, 1, Len( cCaption ) - 1 ) )

                  i ++
                  DO WHILE i <= Len( ::aLine )
                     cLine := Upper( ::aLine[i] )
                     IF At( 'END STATUSBAR', cLine ) # 0 .OR. At( 'STATUSITEM ', cLine ) # 0 .OR. At( 'KEYBOARD ', cLine ) # 0 .OR. At( 'DATE ', cLine ) # 0 .OR. At( 'CLOCK ', cLine ) # 0
                        EXIT
                     ELSEIF ( nAt := At( 'WIDTH ', cLine ) ) # 0
                        nWidth := RTrim( SubStr( ::aLine[i], nAt + 6 ) )
                        i ++
                        IF Right( nWidth, 1 ) == ";"
                           nWidth := Val( AllTrim( SubStr( nWidth, 1, Len( nWidth ) - 1 ) ) )
                        ELSE
                           nWidth := Val( AllTrim( nWidth ) )
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'ACTION ', cLine ) ) # 0
                        cAction := RTrim( SubStr( ::aLine[i], nAt + 7 ) )
                        i ++
                        IF Right( cAction, 1 ) == ";"
                           cAction := AllTrim( SubStr( cAction, 1, Len( cAction ) - 1 ) )
                        ELSE
                           cAction := AllTrim( cAction )
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'ICON ', cLine ) ) # 0
                        cIcon := RTrim( SubStr( ::aLine[i], nAt + 5 ) )
                        i ++
                        IF Right( cIcon, 1 ) == ";"
                           cIcon := AllTrim( SubStr( cIcon, 1, Len( cIcon ) - 1 ) )
                        ELSE
                           cIcon := AllTrim( cIcon )
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'AMPM ', cLine ) ) # 0
                        lAmPm := RTrim( SubStr( ::aLine[i], nAt + 5 ) )
                        i ++
                        IF Right( lAmPm, 1 ) == ";"
                           lAmPm := AllTrim( SubStr( lAmPm, 1, Len( lAmPm ) - 1 ) )
                           IF Empty( lAmPm )
                              lAmPm := .T.
                           ELSE
                              lAmPm := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lAmPm := .T.
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'FLAT ', cLine ) ) # 0
                        lFlat := RTrim( SubStr( ::aLine[i], nAt + 5 ) )
                        i ++
                        IF Right( lFlat, 1 ) == ";"
                           lFlat := AllTrim( SubStr( lFlat, 1, Len( lFlat ) - 1 ) )
                           IF Empty( lFlat )
                              lFlat := .T.
                           ELSE
                              lFlat := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lFlat := .T.
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'RAISED ', cLine ) ) # 0
                        lRaised := RTrim( SubStr( ::aLine[i], nAt + 7 ) )
                        i ++
                        IF Right( lRaised, 1 ) == ";"
                           lRaised := AllTrim( SubStr( lRaised, 1, Len( lRaised ) - 1 ) )
                           IF Empty( lRaised )
                              lRaised := .T.
                           ELSE
                              lRaised := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lRaised := .T.
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'TOOLTIP ', cLine ) ) # 0
                        cToolTip := RTrim( SubStr( ::aLine[i], nAt + 8 ) )
                        i ++
                        IF Right( cToolTip, 1 ) == ";"
                           cToolTip := AllTrim( SubStr( cToolTip, 1, Len( cToolTip ) - 1 ) )
                        ELSE
                           cToolTip := AllTrim( cToolTip )
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'CENTER ', cLine ) ) # 0
                        lCenter := RTrim( SubStr( ::aLine[i], nAt + 7 ) )
                        i ++
                        IF Right( lCenter, 1 ) == ";"
                           lCenter := AllTrim( SubStr( lCenter, 1, Len( lCenter ) - 1 ) )
                           IF Empty( lCenter )
                              lCenter := .T.
                           ELSE
                              lCenter := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lCenter := .T.
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'LEFT ', cLine ) ) # 0
                        lLeft := RTrim( SubStr( ::aLine[i], nAt + 5 ) )
                        i ++
                        IF Right( lLeft, 1 ) == ";"
                           lLeft := AllTrim( SubStr( lLeft, 1, Len( lLeft ) - 1 ) )
                           IF Empty( lLeft )
                              lLeft := .T.
                           ELSE
                              lLeft := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lLeft := .T.
                           EXIT
                        ENDIF
                     ELSEIF ( nAt := At( 'RIGHT ', cLine ) ) # 0
                        lRight := RTrim( SubStr( ::aLine[i], nAt + 6 ) )
                        i ++
                        IF Right( lRight, 1 ) == ";"
                           lRight := AllTrim( SubStr( lRight, 1, Len( lRight ) - 1 ) )
                           IF Empty( lRight )
                              lRight := .T.
                           ELSE
                              lRight := .T.
                              EXIT
                           ENDIF
                        ELSE
                           lRight := .T.
                           EXIT
                        ENDIF
                     ELSE
                        i ++
                        EXIT
                     ENDIF
                  ENDDO
               ELSE
                  cCaption := AllTrim( cCaption )
                  i ++
               ENDIF

               IF nProcess == 1      // STATUSITEM
                  ::cSCaption += IIF( Empty( cCaption ), "' '", cCaption ) + ", "
                  ::cSWidth   += IIF( nWidth > 0, LTrim( Str( nWidth ) ), "0" ) + ", "
                  ::cSAction  += IIF( Empty( cAction ), "''", StrToStr( cAction ) ) + ", "
                  ::cSIcon    += IIF( Empty( cIcon ), "''", cIcon ) + ", "
                  ::cSStyle   += IIF( lFlat, "'FLAT'", IIF( lRaised, "'RAISED'", "''" ) ) + ", "
                  ::cSToolTip += IIF( Empty( cToolTip ), "''", cToolTip ) + ", "
                  ::cSAlign   += IIF( lLeft, "'LEFT'", IIF( lRight, "'RIGHT'", IIF( lCenter, "'CENTER'", "''" ) ) ) + ", "
               ELSEIF nProcess == 2      // KEYBOARD
                  ::nSKWidth   := nWidth
                  ::cSKAction  := ::Clean( cAction )
                  ::cSKToolTip := ::Clean( cToolTip )
                  ::cSKImage   := ::Clean( cIcon )
                  ::cSKStyle   := IIF( lFlat, 'FLAT', IIF( lRaised, 'RAISED', '' ) )
                  ::cSKAlign   := IIF( lLeft, 'LEFT', IIF( lRight, 'RIGHT', IIF( lCenter, 'CENTER', '' ) ) )
               ELSEIF nProcess == 3      // DATE
                  ::nSDWidth   := nWidth
                  ::cSDAction  := ::Clean( cAction )
                  ::cSDToolTip := ::Clean( cToolTip )
                  ::cSDStyle   := IIF( lFlat, 'FLAT', IIF( lRaised, 'RAISED', '' ) )
                  ::cSDAlign   := IIF( lLeft, 'LEFT', IIF( lRight, 'RIGHT', IIF( lCenter, 'CENTER', '' ) ) )
               ELSE                      // CLOCK
                  ::nSCWidth   := nWidth
                  ::cSCAction  := ::Clean( cAction )
                  ::cSCToolTip := ::Clean( cToolTip )
                  ::lSCAmPm    := lAmPm
                  ::cSCImage   := ::Clean( cIcon )
                  ::cSCStyle   := IIF( lFlat, 'FLAT', IIF( lRaised, 'RAISED', '' ) )
                  ::cSCAlign   := IIF( lLeft, 'LEFT', IIF( lRight, 'RIGHT', IIF( lCenter, 'CENTER', '' ) ) )
               ENDIF
            ELSE
               i ++
            ENDIF
         ENDDO

         IF ! lItem
            ::cSCaption += "' ' }"
            ::cSWidth   += "'' }"
            ::cSAction  += "'' }"
            ::cSIcon    += "'' }"
            ::cSStyle   += "'' }"
            ::cSToolTip += "'' }"
            ::cSAlign   += "'' }"
         ELSE
            ::cSCaption := SubStr( ::cSCaption, 1, Len( ::cSCaption ) - 2 ) + " }"
            ::cSWidth   := SubStr( ::cSWidth, 1, Len( ::cSWidth ) - 2 ) + " }"
            ::cSAction  := SubStr( ::cSAction, 1, Len( ::cSAction ) - 2 ) + " }"
            ::cSIcon    := SubStr( ::cSIcon, 1, Len( ::cSIcon ) - 2 ) + " }"
            ::cSStyle   := SubStr( ::cSStyle, 1, Len( ::cSStyle ) - 2 ) + " }"
            ::cSToolTip := SubStr( ::cSToolTip, 1, Len( ::cSToolTip ) - 2 ) + " }"
            ::cSAlign   := SubStr( ::cSAlign, 1, Len( ::cSAlign ) - 2 ) + " }"
         ENDIF

         EXIT
      ELSE
         ::lSStat := .F.

         ::Form_Main:butt_status:Value := .F.
         ::cvcControls:Control_Stabusbar:Visible := .F.
      ENDIF
   NEXT i

   // Controls
   FOR i := 1 TO ::nControlW
      IF i == 1
        cTipo := 'FORM'
      ELSE
        cTipo := ::LeaTipo( ::aControlW[i] )
      ENDIF

      /*
         Por cada nuevo control se debe agregar un CASE llamando a la funci�n que carga las propiedades desde el form.
         Por cada nueva propiedad se debe agrebar una l�nea en la correspondiente p(funci�n) para cargar su valor desde el form.
      */
      DO CASE
      CASE cTipo == 'DEFINE'
         ::aCtrlType[i] := 'STATUSBAR'
      CASE cTipo == 'FORM'
         ::pForm( i )
      CASE cTipo == 'BUTTON'
         ::pButton( i )
      CASE cTipo == "CHECKBOX"
         ::pCheckBox( i )
      CASE cTipo == "LISTBOX"
         ::pListBox( i )
      CASE cTipo == 'COMBOBOX'
         ::pComboBox( i )
      CASE cTipo == 'CHECKBTN'
         ::pCheckBtn( i )
      CASE cTipo == 'PICCHECKBUTT'
         ::pPicCheckButt( i )
      CASE cTipo == "PICBUTT"
         ::pPicButt( i )
      CASE cTipo == "IMAGE"
         ::pImage( i )
      CASE cTipo == "ANIMATEBOX"
         ::pAnimateBox( i )
      CASE cTipo == "DATEPICKER"
         ::pDatePicker( i )
      CASE cTipo == 'GRID'
         ::pGrid( i )
      CASE cTipo == 'BROWSE'
         ::pBrowse( i )
      CASE cTipo == 'FRAME'
         ::pFrame( i )
      CASE cTipo == "TEXTBOX"
         ::pTextBox( i )
      CASE cTipo == "EDITBOX"
         ::pEditBox( i )
      CASE cTipo == 'RADIOGROUP'
         ::pRadioGroup( i )
      CASE cTipo == "PROGRESSBAR"
         ::pProgressBar( i )
      CASE cTipo == 'SLIDER'
         ::pSlider( i )
      CASE cTipo == 'SPINNER'
         ::pSpinner( i )
      CASE cTipo == "PLAYER"
         ::pPlayer( i )
      CASE cTipo == 'LABEL'
         ::pLabel( i )
      CASE cTipo == "TIMER"
         ::pTimer( i )
      CASE cTipo == 'IPADDRESS'
         ::pIPAddress( i )
      CASE cTipo == 'MONTHCALENDAR'
         ::pMonthCal( i )
      CASE cTipo == 'HYPERLINK'
         ::pHypLink( i )
      CASE cTipo == 'TREE'
         ::pTree( i )
      CASE cTipo == 'RICHEDITBOX'
         ::pRichedit( i )
      CASE cTipo == 'TAB'
         ::swTab := .T.
         ::pTab( i )
      CASE cTipo == "TIMEPICKER"
         ::pTimePicker( i )
      CASE cTipo == 'XBROWSE'
         ::pXBrowse( i )
      OTHERWISE
         ::pLabel( i )
      ENDCASE
   NEXT i

   ::myTbEditor:CreateToolbarFromFile()

   // Main menu
   TMyMenuEditor():CreateMenuFromFile( Self, 1 )

   // Context menu
   TMyMenuEditor():CreateMenuFromFile( Self, 2 )

   // Notify menu
   TMyMenuEditor():CreateMenuFromFile( Self, 3 )

   // Show statusbar
   IF ::lSStat
      ::CreateStatusBar()
   ENDIF

   IF ::nControlW == 1
      ::myHandle := 0
      ::nHandleP := 0
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Control_Click( wpar ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cControl, i

   STATIC lIdle := .T.

   IF lIdle
      lIdle := .F.
      FOR i := 1 TO 31
         cControl := 'Control_' + StrZero( i, 2, 0 )
         ::cvcControls:&cControl:Value := .F.
      NEXT i
      ::CurrentControl := wpar
      cControl := 'Control_' + StrZero( wpar, 2, 0 )
      ::cvcControls:&cControl:Value := .T.
      IF wpar > 1 .AND. wpar < 31
         EraseWindow( ::oDesignForm:Name )
         ::MisPuntos()
         ::oCtrlList:Value := {}
         ::lAddingNewControl := .T.
      ELSE
         ::lAddingNewControl := .F.
      ENDIF
      lIdle := .T.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD LeaTipo( cName ) CLASS TFormEditor
//------------------------------------------------------------------------------
Local q, r, s, cRegresa := '', zi, zl, cvc

   cvc := aScan( ::aControlW, { |c| Lower( c ) == Lower( cName ) } )
   zi  := IIF( cvc > 0, ::aSpeed[cvc], 1)
   zl  := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )

   FOR q := zi TO zl
      s := At( ' ' + Upper( cname ) + ' ', Upper( ::aLine[q] ) )
      If s > 0
         FOR r := 1 TO s
            IF Asc( SubStr( ::aLine[q], r, 1 ) ) >= 65
               cRegresa := AllTrim( SubStr( ::aLine[q], r, s - r ) )
               EXIT
            ENDIF
         NEXT r
         EXIT
      ENDIF
   NEXT q

   IF Upper( cRegresa ) == 'CHECKBUTTON'
      IF ::LeaDatoLogic( cname, 'CAPTION', 'F' ) ==  'T'
         cRegresa := 'CHECKBTN'
      ELSE
         cRegresa := 'PICCHECKBUTT'
      ENDIF
   ENDIF
   IF Upper( cRegresa ) == 'BUTTON'
      IF ::LeaDatoLogic( cname, 'CAPTION', 'F' ) == 'T'
         cRegresa := 'BUTTON'
      ELSE
         cRegresa := 'PICBUTT'
      ENDIF
   ENDIF
RETURN cRegresa

//------------------------------------------------------------------------------
METHOD LeaDato( cName, cPropmet, cDefault ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, sw := 0, zi, cvc, zl, nPos, cFValue

   cvc := aScan( ::aControlW, { |c| Lower( c ) == Lower( cName ) } )
   zi  := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl  := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( cName ) + ' ' , Upper( ::aLine[i] ) ) # 0 .AND. sw == 0  ///// ubica el control en la forma y a partir de ah� busca la propiedad
         sw := 1
      ELSE
         IF sw == 1
            IF Len( RTrim( ::aLine[i] ) ) == 0
               RETURN cDefault
            ENDIF
            nPos := At( ' ' + Upper( cPropmet ) + ' ', Upper( ::aLine[i] ) )
            IF nPos > 0
               cFValue := SubStr( ::aLine[i], nPos + Len( cPropmet ) + 2 )
               cFValue := RTrim( cFValue)
               IF Right( cFValue, 1 ) == ";"
                  cFValue := SubStr( cFValue, 1, Len( cFValue ) - 1 )
               ENDIF
               cFValue := AllTrim( cFValue )
               IF Len( cFValue ) == 0
                  RETURN cDefault
               ELSEIF Upper( cFValue ) == 'NIL'
                  RETURN 'NIL'
               ELSE
                  RETURN cFValue
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

//------------------------------------------------------------------------------
METHOD LeaDatoStatus( cName, cPropmet, cDefault ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, sw := 0, zi, cvc, zl, nPos, cFValue

   cvc := aScan( ::aControlW, { |c| Lower( c ) == Lower( cName ) } )
   zi  := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl  := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( cName ) + ' ' , Upper( ::aLine[i] ) ) # 0 .AND. sw == 0
         sw := 1
      ELSE
         IF sw == 1
            IF Len( RTrim( ::aLine[i] ) ) == 0
               RETURN cDefault
            ENDIF
            nPos := At( ' ' + Upper( cPropmet ) + ' ', Upper( ::aLine[i] ) )
            IF nPos > 0
               cFValue := SubStr( ::aLine[i], nPos + Len( cPropmet ) + 2 )
               cFValue := RTrim( cFValue)
               IF Right( cFValue, 1 ) == ";"
                  cFValue := SubStr( cFValue, 1, Len( cFValue ) - 1 )
               ENDIF
               cFValue := AllTrim( cFValue )
               IF Len( cFValue ) == 0
                  RETURN cDefault
               ELSEIF Upper( cFValue ) == 'NIL'
                  RETURN 'NIL'
               ELSE
                  RETURN cFValue
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

//------------------------------------------------------------------------------
METHOD LeaDatoLogic( cName, cPropmet, cDefault ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, sw := 0, zi, cvc, zl

   IF ! cDefault $ "TF"
      cDefault := "F"
   ENDIF

   cvc := aScan( ::aControlW, { |c| Lower( c ) == Lower( cName ) } )
   zi  := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl  := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( cName ) + ' ', Upper( ::aLine[i] ) ) # 0 .AND. sw == 0
         sw := 1
      ELSE
         IF sw == 1
            IF Len( RTrim( ::aLine[i] ) ) == 0
               RETURN cDefault
            ENDIF
            IF At( ' ' + Upper( cPropmet ) + ' ', Upper( ::aLine[i] ) ) > 0
               RETURN 'T'
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

//------------------------------------------------------------------------------
METHOD LeaRow( cName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, nPos, nRow := '0', zi, zl, cvc

   cvc := aScan( ::aControlW, { |c| Lower( c ) == Lower( cName ) } )
   zi := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( cname ) + ' ', Upper( ::aLine[i] ) ) # 0
         nPos := At( ",", ::aLine[i] )
         nRow := Left( ::aLine[i], nPos - 1 )
         nRow := StrTran( nRow, "@", "" )
         EXIT
      ENDIF
   NEXT i
RETURN nRow

//------------------------------------------------------------------------------
METHOD LeaRowF( cName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, nPos1, nPos2, nRow := '0', zi, zl, cvc

   cvc := aScan( ::aControlW, { |c| Lower( c ) == Lower( cName ) } )
   zi := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( 'WINDOW' ) + ' ', Upper( ::aLine[i] ) ) # 0
         nPos1 := At( 'AT', Upper(::aLine[i + 1] ) )
         nPos2 := At( ",", ::aLine[i + 1])
         nRow := SubStr( ::aLine[i + 1], nPos1 + 3, Len( ::aLine[i + 1] ) - nPos2 )
         EXIT
      ENDIF
   NEXT i
RETURN nRow

//------------------------------------------------------------------------------
METHOD LeaCol( cName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, nPos, nCol := '0', zi, zl, cvc

   cvc := aScan( ::aControlW, { |c| Lower( c ) == Lower( cName ) } )
   zi := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   For i := zi TO zl
      IF At( ' ' + Upper( cName ) + ' ', Upper( ::aLine[i] ) ) # 0
         nPos := At( ",", ::aLine[i] )
         nCol := SubStr( ::aLine[i], nPos + 1 )
         nCol := LTrim( nCol )
         FOR nPos := 1 TO Len( nCol )
            // Stop at the first letter
            IF Asc( SubStr( nCol, nPos, 1 ) ) >= 65
               EXIT
            ENDIF
         NEXT nPos
         nCol := SubStr( nCol, 1, nPos - 1 )
         EXIT
      ENDIF
   NEXT i
RETURN nCol

//------------------------------------------------------------------------------
METHOD LeaColF( cName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, nPos, nCol := '0', zi, zl, cvc

   cvc := aScan( ::aControlW, { |c| Lower( c ) == Lower( cName ) } )
   zi := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( 'WINDOW' ) + ' ', Upper( ::aLine[i] ) ) # 0
         nPos := At( ",", ::aLine[i + 1] )
         nCol := RTrim( SubStr( ::aLine[i + 1], nPos + 1 ) )
         IF Right( nCol, 1 ) == ";"
            nCol := SubStr( nCol, 1, Len( nCol ) - 1 )
         ENDIF
         EXIT
      ENDIF
   NEXT i
RETURN nCol

//------------------------------------------------------------------------------
METHOD Clean( cData ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cIni, cFin

   cIni := Left( cData, 1 )
   cFin := Right( cData, 1 )
   IF cIni == "'" .OR. cIni == '"'
      IF cIni == cFin
         cData := SubStr( cData, 2, Len( cData ) - 2 )
      ENDIF
   ENDIF
RETURN cData

//------------------------------------------------------------------------------
METHOD LeaDato_Oop( cName, cPropmet, cDefault ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, zi, zl, cvc, nPos, cValue

   cvc := aScan( ::aControlW, { |c| Lower( c ) == Lower( cName) } )
   zi := IIF( cvc > 0, ::aSpeed[cvc], 1 )
   zl := IIF( cvc > 0, ::aNumber[cvc], Len( ::aLine ) )
   FOR i := zi TO zl
      IF At( ' ' + Upper( ::cFName ) + '.' + Upper( cName ) + '.' + Upper( cPropmet ), Upper( ::aLine[i] ) ) > 0
         nPos := RAt( '=', ::aLine[i] ) + 1
         IF nPos > 1
            cValue := RTrim( SubStr( ::aLine[i], nPos ) )
            IF Empty( cValue )
               RETURN cDefault
            ELSEIF Upper( cValue ) == 'NIL'
               RETURN 'NIL'
            ELSE
               RETURN cValue
            ENDIF
         ENDIF
      ENDIF
   NEXT i
RETURN cDefault

//------------------------------------------------------------------------------
METHOD MisPuntos() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL hDC, nHeight, nWidth, i, j

   nHeight := ::oDesignForm:ClientHeight
   nWidth  := ::oDesignForm:ClientWidth

   IF _IsControlDefined( 'Statusbar', ::oDesignForm:Name )
      nHeight -= ::oDesignForm:Statusbar:ClientHeightUsed
   ENDIF

   hDC := HB_GetDC( ::oDesignForm:hWnd )

   FOR i := 0 TO nWidth STEP 10
      FOR j := 0 TO nHeight STEP 10
         SetPixel( hDC, i, j, RGB( 0, 0, 0 ) )
      NEXT
   NEXT

   HB_ReleaseDC( ::oDesignForm:hWnd, hDC )

   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) AT 480, 001 TO 480, nWidth  PENCOLOR { 255, 0, 0 } PENWIDTH 1
   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) AT 600, 001 TO 600, nWidth  PENCOLOR { 255, 0, 0 } PENWIDTH 1
   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) AT 001, 640 TO nHeight, 640 PENCOLOR { 255, 0, 0 } PENWIDTH 1
   DRAW LINE IN WINDOW ( ::oDesignForm:Name ) AT 001, 800 TO nHeight, 800 PENCOLOR { 255, 0, 0 } PENWIDTH 1
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTree( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aFontColor
LOCAL lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled
LOCAL cToolTip, cOnChange, cOnGotFocus, cOnLostFocus, cOnDblClick, cNodeimages
LOCAL cItemImages, lNoRootButton, lItemIds, nHelpId, lFull, nValue, lRTL
LOCAL cOnEnter, lBreak, lNoTabStop, aSelColor, lSelBold, lCheckBoxes
LOCAL lEditLabels, lNoHScroll, lNoScroll, lHotTrack, lButtons, lEnableDrag
LOCAL lEnableDrop, aTarget, lSingleExpand, lNoBorder, cOnLabelEdit, cValid
LOCAL cOnCheckChg, nIndent, cOnDrop, lNoLines

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::LeaDato( cName, 'OBJ', '' )
   nRow          := Val( ::LeaDato( cName, 'AT', '100' ) )
   nCol          := Val( ::LeaCol( cName ) )
   nWidth        := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
   nHeight       := Val( ::LeaDato( cName, 'HEIGHT', '120' ) )
   cFontName     := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize     := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   aFontColor    := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor    := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lBold         := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold         := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic       := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic       := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline    := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline    := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout    := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout    := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor    := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible      := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip      := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnChange     := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnGotFocus   := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus  := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   cOnDblClick   := ::LeaDato( cName, 'ON DBLCLICK', '' )
   cNodeImages   := ::LeaDato( cName, 'NODEIMAGES', '' )
   cItemImages   := ::LeaDato( cName, 'ITEMIMAGES', '' )
   lNoRootButton := ( ::LeaDatoLogic( cName, 'NOROOTBUTTON', "F" ) == "T" )
   lItemIds      := ( ::LeaDatoLogic( cName, 'ITEMIDS', "F" ) == "T" )
   nHelpId       := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lFull         := ( ::LeaDatoLogic( cName, 'FULLROWSELECT', "F" ) == "T" )
   nValue        := Val( ::LeaDato( cName, 'VALUE', '0' ) )
   lRTL          := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   cOnEnter      := ::LeaDato( cName, 'ON ENTER', '' )
   lBreak        := ( ::LeaDatoLogic( cName, "BREAK", "F" ) == "T" )
   lNoTabStop    := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )
   aSelColor     := UpperNIL( ::LeaDato( cName, 'SELCOLOR', 'NIL' ) )
   lSelBold      := ( ::LeaDatoLogic( cName, 'SELBOLD', "F" ) == "T" )
   lCheckBoxes   := ( ::LeaDatoLogic( cName, 'CHECKBOXES', "F" ) == "T" )
   lEditLabels   := ( ::LeaDatoLogic( cName, 'EDITLABELS', "F" ) == "T" )
   lNoHScroll    := ( ::LeaDatoLogic( cName, "NOHSCROLL", "F" ) == "T" )
   lNoScroll     := ( ::LeaDatoLogic( cName, "NOSCROLL", "F" ) == "T" )
   lHotTrack     := ( ::LeaDatoLogic( cName, "HOTTRACKING", "F" ) == "T" )
   lButtons      := ( ::LeaDatoLogic( cName, "NOBUTTONS", "F" ) == "T" )
   lEnableDrag   := ( ::LeaDatoLogic( cName, "ENABLEDRAG", "F" ) == "T" )
   lEnableDrop   := ( ::LeaDatoLogic( cName, "ENABLEDROP", "F" ) == "T" )
   aTarget       := ::LeaDato( cName, 'TARGET', '' )
   lSingleExpand := ( ::LeaDatoLogic( cName, "SINGLEEXPAND", "F" ) == "T" )
   lNoBorder     := ( ::LeaDatoLogic( cName, "BORDERLESS", "F" ) == "T" )
   cOnLabelEdit  := ::LeaDato( cName, 'ON LABELEDIT', '' )
   cValid        := ::LeaDato( cName, 'VALID', "" )
   cOnCheckChg   := ::LeaDato( cName, 'ON CHECKCHANGE', '' )
   nIndent       := Val( ::LeaDato( cName, 'INDENT', '' ) )
   cOnDrop       := ::LeaDato( cName, 'ON DROP', '' )
   lNoLines      := ( ::LeaDatoLogic( cName, 'NOLINES', "F" ) == "T" )

   // Show control
   DEFINE TREE &cName OF ( ::oDesignForm:Name ) ;
      AT nRow, nCol ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      ON GOTFOCUS ::Dibuja( this:name ) ;
      ON CHANGE ::Dibuja( this:name )

      NODE 'Tree'
      END NODE

      NODE 'Nodes'
      END NODE
   END TREE
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]      := 'TREE'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnDblClick[i]    := cOnDblClick
   ::aNodeImages[i]    := cNodeImages
   ::aItemImages[i]    := cItemImages
   ::aNoRootButton[i]  := lNoRootButton
   ::aItemIDs[i]       := lItemIds
   ::aHelpID[i]        := nHelpId
   ::aFull[i]          := lFull
   ::aValue[i]         := nValue
   ::aRTL[i]           := lRTL
   ::aOnEnter[i]       := cOnEnter
   ::aBreak[i]         := lBreak
   ::aNoTabStop[i]     := lNoTabStop
   ::aSelColor[i]      := aSelColor
   ::aSelBold[i]       := lSelBold
   ::aCheckBoxes[i]    := lCheckBoxes
   ::aEditLabels[i]    := lEditLabels
   ::aNoHScroll[i]     := lNoHScroll
   ::aNoVScroll[i]     := lNoScroll
   ::aHotTrack[i]      := lHotTrack
   ::aButtons[i]       := lButtons
   ::aDrag[i]          := lEnableDrag
   ::aDrop[i]          := lEnableDrop
   ::aTarget[i]        := aTarget
   ::aSingleExpand[i]  := lSingleExpand
   ::aBorder[i]        := lNoBorder
   ::aOnLabelEdit[i]   := cOnLabelEdit
   ::aValid[i]         := cValid
   ::aOnCheckChg[i]    := cOnCheckChg
   ::aIndent[i]        := nIndent
   ::aOnDrop[i]        := cOnDrop
   ::aNoLines[i]       := lNoLines

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTab( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, nValue
LOCAL cToolTip, cImage, cOnChange, lFlat, lVertical, lButtons, lHotTrack, lBold
LOCAL lItalic, lUnderline, lStrikeout, aFontColor, lVisible, lEnabled
LOCAL lNoTabStop, lRTL, lMultiLine, cSubClass, lInternals, cPObj, nPosSub, cPSub
LOCAL cPCaptions, cPImages, cPNames, cPObjs, cPSubs, nPageCount, j
LOCAL nPosPage, cPCaption, cPName, nPosImage, cPImage, nPosName, nPosObj

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::LeaDato( cName, 'OBJ', '' )
   nRow          := Val( ::LeaDato( cName, 'AT', '100' ) )
   nCol          := Val( ::LeaCol( cName ) )
   nWidth        := Val( ::LeaDato( cName, 'WIDTH', '0' ) )
   nHeight       := Val( ::LeaDato( cName, 'HEIGHT', '0' ) )
   cFontName     := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize     := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   nValue        := ::LeaDato( cName, 'VALUE', '0' )
   cToolTip      := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cImage        := ::Clean( ::LeaDato( cName, 'IMAGE', '' ) )
   cOnChange     := ::LeaDato( cName, 'ON CHANGE', '' )
   lFlat         := ( ::LeaDatoLogic( cName, 'FLAT', "F" ) == "T" )
   lVertical     := ( ::LeaDatoLogic( cName, 'VERTICAL', "F" ) == "T" )
   lButtons      := ( ::LeaDatoLogic( cName, 'BUTTONS', "F" ) == "T" )
   lHotTrack     := ( ::LeaDatoLogic( cName, 'HOTTRACK', "F" ) == "T" )
   lBold         := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold         := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic       := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic       := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline    := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline    := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout    := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout    := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aFontColor    := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor    := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lVisible      := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lNoTabStop    := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )
   lRTL          := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lMultiLine    := ( ::LeaDatoLogic( cName, 'MULTILINE', "F" ) == "T" )
   cSubClass     := ::LeaDato( cName, 'SUBCLASS', '' )
   lInternals    := ( ::LeaDatoLogic( cName, 'INTERNALS', "F" ) == "T" )

   // Show control
   DEFINE TAB &cName OF ( ::oDesignForm:Name ) ;
      AT nRow, nCol ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      TOOLTIP 'To access Properties and Events right click on header area.' ;
      ON CHANGE ::Dibuja( This:Name )
   END TAB
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]      := 'TAB'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aValue[i]         := nValue
   ::aToolTip[i]       := cToolTip
   ::aImage[i]         := cImage
   ::aOnChange[i]      := cOnChange
   ::aFlat[i]          := lFlat
   ::aVertical[i]      := lVertical
   ::aButtons[i]       := lButtons
   ::aHotTrack[i]      := lHotTrack
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aFontColor[i]     := aFontColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aNoTabStop[i]     := lNoTabStop
   ::aRTL[i]           := lRTL
   ::aMultiLine[i]     := lMultiLine
   ::aSubClass[i]      := cSubClass
   ::aVirtual[i]       := lInternals

   // Load pages
   cPCaptions := '{ '
   cPImages   := '{ '
   cPNames    := '{ '
   cPObjs     := '{ '
   cPSubs     := '{ '
   nPageCount := 0

   j := 1
   DO WHILE j <= Len( ::aLine ) .AND. At( ' ' + Upper( cName ) + ' ', Upper( ::aLine[j] ) ) == 0
     j ++
   ENDDO

   DO WHILE j <= Len( ::aLine ) .AND. At( 'END TAB', Upper( ::aLine[j] ) ) == 0
      IF ( nPosPage := At( 'DEFINE PAGE ', Upper( ::aLine[j] ) ) ) # 0
         nPageCount ++

         cPCaption := AllTrim( SubStr( ::aLine[j], nPospage + 11, Len( ::aLine[j] ) ) )
         IF Right( cPCaption, 1 ) == ";"
            cPCaption := AllTrim( SubStr( cPCaption, 1, Len( cPCaption ) - 1 ) )
         ENDIF
         cPCaption := ::Clean( cPCaption )
         j ++

         cPImage := ''
         cPName  := ''
         cPObj   := ''
         cPSub   := ''

         DO WHILE j <= Len( ::aLine ) .AND. At( 'END TAB', Upper( ::aLine[j] ) ) == 0 .AND. At( 'END PAGE ', Upper( ::aLine[j] ) ) == 0
            DO CASE
            CASE ( nPosImage := At( 'IMAGE ', Upper( ::aLine[j] ) ) ) > 0
               cPImage := AllTrim( SubStr( ::aLine[j], nPosImage + 6, Len( ::aLine[j] ) ) )
               cPImage := ::Clean( AllTrim( SubStr( cPImage, 1, Len( ::aLine[j] ) ) ) )
            CASE ( nPosName := At( 'NAME ', Upper( ::aLine[j] ) ) ) > 0
               cPName := AllTrim( SubStr( ::aLine[j], nPosName + 5, Len( ::aLine[j] ) ) )
               cPName := ::Clean( AllTrim( SubStr( cPName, 1, Len( ::aLine[j] ) ) ) )
            CASE ( nPosObj := At( 'OBJ ', Upper( ::aLine[j] ) ) ) > 0
               cPObj := AllTrim( SubStr( ::aLine[j], nPosObj + 4, Len( ::aLine[j] ) ) )
               cPObj := ::Clean( AllTrim( SubStr( cPObj, 1, Len( ::aLine[j] ) ) ) )
            CASE ( nPosSub := At( 'SUBCLASS ', Upper( ::aLine[j] ) ) ) > 0
               cPSub := AllTrim( SubStr( ::aLine[j], nPosSub + 9, Len( ::aLine[j] ) ) )
               cPSub := ::Clean( AllTrim( SubStr( cPSub, 1, Len( ::aLine[j] ) ) ) )
            ENDCASE

            j ++
         ENDDO

         IF ! Empty( cPCaption )
            ::oDesignForm:&cName:AddPage( nPageCount, cPCaption, cPImage, NIL, NIL, cPName )

            cPCaptions := cPCaptions + "'" + cPCaption + "', "
            cPImages   := cPImages + "'" + cPImage + "', "
            cPNames    := cPNames + "'" + cPName + "', "
            cPObjs     := cPObjs + "'" + cPObj + "', "
            cPSubs     := cPSubs + "'" + cPSub + "', "
         ENDIF
      ELSE
         j ++
      ENDIF
   ENDDO

   cPCaptions := SubStr( cPCaptions, 1, Len( cPCaptions ) - 2 ) + ' }'
   cPImages   := SubStr( cPImages, 1, Len( cPImages ) - 2 ) + ' }'
   cPNames    := SubStr( cPNames, 1, Len( cPNames ) - 2 ) + ' }'
   cPObjs     := SubStr( cPObjs, 1, Len( cPObjs ) - 2 ) + ' }'
   cPSubs     := SubStr( cPSubs, 1, Len( cPSubs ) - 2 ) + ' }'

   ::aCaption[i]        := cPCaptions
   ::aImage[i]          := cPImages
   ::aPageNames[i]      := cPNames
   ::aPageObjs[i]       := cPObjs
   ::aPageSubClasses[i] := cPSubs
RETURN NIL

//------------------------------------------------------------------------------
METHOD pIpAddress( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cValue, cFontName, nFontSize
LOCAL aFontColor, lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible
LOCAL lEnabled, cToolTip, cOnChange, cOngotfocus, cOnLostfocus, nHelpId
LOCAL lNoTabStop, lRTL, cSubClass

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '24' ) )
   cValue       := ::LeaDato( cName, 'VALUE', '' )
   cFontName    := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   aFontColor   := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnChange    := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnGotfocus  := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostfocus := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   nHelpId      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lNoTabStop   := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   cSubClass    := ::LeaDato( cName, 'SUBCLASS', '' )

   // Show control
   IF lRTL
     @ nRow, nCol LABEL &cName ;
        OF ( ::oDesignForm:Name ) ;
        WIDTH nWidth ;
        HEIGHT nHeight ;
        RTL ;
        VALUE IIF( Empty( cValue ), '   .   .   .   ', cValue ) ;
        BACKCOLOR WHITE ;
        CLIENTEDGE ;
        ACTION ::Dibuja( This:Name )
   ELSE
     @ nRow, nCol LABEL &cName ;
        OF ( ::oDesignForm:Name ) ;
        WIDTH nWidth ;
        HEIGHT nHeight ;
        VALUE IIF( Empty( cValue ), '   .   .   .   ', cValue ) ;
        BACKCOLOR WHITE ;
        CLIENTEDGE ;
        ACTION ::Dibuja( This:Name )
   ENDIF
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]      := 'IPADDRESS'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aValue[i]         := cValue
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aHelpID[i]        := nHelpId
   ::aNoTabStop[i]     := lNoTabStop
   ::aRTL[i]           := lRTL
   ::aSubClass[i]      := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTimer( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, lEnabled, nInterval, cAction, cSubClass

   // Load properties
   cName     := ::aControlW[i]
   cObj      := ::LeaDato( cName, 'OBJ', '' )
   nRow      := Val( ::LeaDato( cName, 'ROW', '0' ) )
   nCol      := Val( ::LeaDato( cName, 'COL', '0' ) )
   lEnabled  := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled  := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   nInterval := Val( ::LeaDato( cName, 'INTERVAL', '1000' ) )
   cAction   := ::LeaDato( cName, 'ACTION', '' )
   cSubClass := ::LeaDato( cName, 'SUBCLASS', '' )

   // Show control
   @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
      WIDTH 100 ;
      HEIGHT 20 ;
      VALUE cName ;
      BORDER ;
      ACTION ::Dibuja( This:Name )

   // Save properties
   ::aCtrlType[i] := 'TIMER'
   ::aName[i]     := cName
   ::aCObj[i]     := cObj
   ::aValueN[i]   := nInterval
   ::aAction[i]   := cAction
   ::aEnabled[i]  := lEnabled
   ::aSubClass[i] := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pForm( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nFRow, nFCol, nFWidth, nFHeight

   ::aCtrlType[i]         := 'FORM'
   nFRow                  := Val( ::LeaRowF( ::cFName ) )
   nFCol                  := Val( ::LeaColF( ::cFName ) )
   ::cFTitle              := ::Clean( ::LeaDato( 'WINDOW', 'TITLE', '' ) )
   nFWidth                := Val( ::LeaDato( 'WINDOW', 'WIDTH', '640' ) )
   nFHeight               := Val( ::LeaDato( 'WINDOW', 'HEIGHT', '480' ) ) + GetTitleHeight()
   ::cFObj                := ::LeaDato( 'WINDOW', 'OBJ', '' )
   ::cFIcon               := ::Clean( ::LeaDato( 'WINDOW', 'ICON', '' ) )
   ::nFVirtualW           := Val( ::LeaDato( 'WINDOW', 'VIRTUAL WIDTH', '0' ) )
   ::nFVirtualH           := Val( ::LeaDato( 'WINDOW', 'VIRTUAL HEIGHT', '0' ) )
   ::lFMain               := ( ::LeaDatoLogic( 'WINDOW', "MAIN", "F" ) == 'T' )
   ::lFChild              := ( ::LeaDatoLogic( 'WINDOW', "CHILD", "F" ) == 'T' )
   ::lFModal              := ( ::LeaDatoLogic( 'WINDOW', "MODAL", "F" ) == 'T' )
   ::lFNoShow             := ( ::LeaDatoLogic( 'WINDOW', "NOSHOW", "F" ) == 'T' )
   ::lFTopmost            := ( ::LeaDatoLogic( 'WINDOW', "TOPMOST", "F" ) == 'T' )
   ::lFNominimize         := ( ::LeaDatoLogic( 'WINDOW', "NOMINIMIZE", "F" ) == 'T' )
   ::lFNomaximize         := ( ::LeaDatoLogic( 'WINDOW', "NOMAXIMIZE", "F" ) == 'T' )
   ::lFNoSize             := ( ::LeaDatoLogic( 'WINDOW', "NOSIZE", "F" ) == 'T' )
   ::lFNoSysMenu          := ( ::LeaDatoLogic( 'WINDOW', "NOSYSMENU", "F" ) == 'T' )
   ::lFNoCaption          := ( ::LeaDatoLogic( 'WINDOW', "NOCAPTION", "F" ) == 'T' )
   ::lFNoAutoRelease      := ( ::LeaDatoLogic( 'WINDOW', "NOAUTORELEASE", "F" ) == 'T' )
   ::lFHelpButton         := ( ::LeaDatoLogic( 'WINDOW', "HELPBUTTON", "F" ) == 'T' )
   ::lFFocused            := ( ::LeaDatoLogic( 'WINDOW', "FOCUSED", "F" ) == 'T' )
   ::lFBreak              := ( ::LeaDatoLogic( 'WINDOW', "BREAK", "F" ) == 'T' )
   ::lFSplitchild         := ( ::LeaDatoLogic( 'WINDOW', "SPLITCHILD", "F" ) == 'T' )
   ::lFGripperText        := ( ::LeaDatoLogic( 'WINDOW', "GRIPPERTEXT", "F" ) == 'T' )
   ::cFOnInit             := ::LeaDato( 'WINDOW', 'ON INIT', '' )
   ::cFOnRelease          := ::LeaDato( 'WINDOW', 'ON RELEASE', '' )
   ::cFOnInteractiveClose := ::LeaDato( 'WINDOW', 'ON INTERACTIVECLOSE', '' )
   ::cFOnMouseClick       := ::LeaDato( 'WINDOW', 'ON MOUSECLICK', '' )
   ::cFOnMouseDrag        := ::LeaDato( 'WINDOW', 'ON MOUSEDRAG', '' )
   ::cFOnMouseMove        := ::LeaDato( 'WINDOW', 'ON MOUSEMOVE', '' )
   ::cFOnSize             := ::LeaDato( 'WINDOW', 'ON SIZE', '' )
   ::cFOnPaint            := ::LeaDato( 'WINDOW', 'ON PAINT', '' )
   ::cFBackcolor          := UpperNIL( ::LeaDato( 'WINDOW', 'BACKCOLOR', 'NIL' ) )
   ::cFCursor             := ::Clean( ::LeaDato( 'WINDOW', 'CURSOR', '' ) )
   ::cFFontName           := ::Clean( ::LeaDato( 'WINDOW', 'FONT', '' ) )           // Do not force a font when form has none, use OOHG default
   ::nFFontSize           := Val( ::LeaDato( 'WINDOW', 'SIZE', '0' ) )
   ::cFFontColor          := ::LeaDato( 'WINDOW', 'FONTCOLOR', 'NIL' )
   ::cFFontColor          := UpperNIL( ::LeaDato_Oop( 'WINDOW', 'FONTCOLOR', ::cFFontColor ) )
   ::cFNotifyIcon         := ::Clean( ::LeaDato( 'WINDOW', 'NOTIFYICON', '' ) )
   ::cFNotifyToolTip      := ::Clean( ::LeaDato( 'WINDOW', 'NOTIFYTOOLTIP', '' ) )
   ::cFOnNotifyClick      := ::LeaDato( 'WINDOW', 'ON NOTIFYCLICK', '' )
   ::cFOnGotFocus         := ::LeaDato( 'WINDOW', 'ON GOTFOCUS', '' )
   ::cFOnLostFocus        := ::LeaDato( 'WINDOW', 'ON LOSTFOCUS', '' )
   ::cFOnScrollUp         := ::LeaDato( 'WINDOW', 'ON SCROLLUP', '' )
   ::cFOnScrollDown       := ::LeaDato( 'WINDOW', 'ON SCROLLDOWN', '' )
   ::cFOnScrollRight      := ::LeaDato( 'WINDOW', 'ON SCROLLRIGHT', '' )
   ::cFOnScrollLeft       := ::LeaDato( 'WINDOW', 'ON SCROLLLEFT', '' )
   ::cFOnHScrollbox       := ::LeaDato( 'WINDOW', 'ON HSCROLLBOX', '' )
   ::cFOnVScrollbox       := ::LeaDato( 'WINDOW', 'ON VSCROLLBOX', '' )
   ::cFOnMaximize         := ::LeaDato( 'WINDOW', 'ON MAXIMIZE', '' )
   ::cFOnMinimize         := ::LeaDato( 'WINDOW', 'ON MINIMIZE', '' )
   ::lFModalSize          := ( ::LeaDatoLogic( 'WINDOW', "MODALSIZE", "F" ) == 'T' )
   ::lFMDI                := ( ::LeaDatoLogic( 'WINDOW', "MDI", "F" ) == 'T' )
   ::lFMDIClient          := ( ::LeaDatoLogic( 'WINDOW', "MDICLIENT", "F" ) == 'T' )
   ::lFMDIChild           := ( ::LeaDatoLogic( 'WINDOW', "MDICHILD", "F" ) == 'T' )
   ::lFInternal           := ( ::LeaDatoLogic( 'WINDOW', "INTERNAL", "F" ) == 'T' )
   ::cFMoveProcedure      := ::LeaDato( 'WINDOW', 'ON MOVE', '' )
   ::cFRestoreProcedure   := ::LeaDato( 'WINDOW', 'ON RESTORE', '' )
   ::lFRTL                := ( ::LeaDatoLogic( 'WINDOW', "RTL", "F" ) == 'T' )
   ::lFClientArea         := ( ::LeaDatoLogic( 'WINDOW', "CLIENTAREA", "F" ) == 'T' )
   ::cFRClickProcedure    := ::LeaDato( 'WINDOW', 'ON RCLICK', '' )
   ::cFMClickProcedure    := ::LeaDato( 'WINDOW', 'ON MCLICK', '' )
   ::cFDblClickProcedure  := ::LeaDato( 'WINDOW', 'ON DBLCLICK', '' )
   ::cFRDblClickProcedure := ::LeaDato( 'WINDOW', 'ON RDBLCLICK', '' )
   ::cFMDblClickProcedure := ::LeaDato( 'WINDOW', 'ON MDBLCLICK', '' )
   ::nFMinWidth           := Val( ::LeaDato( 'WINDOW', 'MINWIDTH', '0' ) )
   ::nFMaxWidth           := Val( ::LeaDato( 'WINDOW', 'MAXWIDTH', '0' ) )
   ::nFMinHeight          := Val( ::LeaDato( 'WINDOW', 'MINHEIGHT', '0' ) )
   ::nFMaxHeight          := Val( ::LeaDato( 'WINDOW', 'MAXHEIGHT', '0' ) )
   ::cFBackImage          := ::Clean( ::LeaDato( 'WINDOW', 'BACKIMAGE', '' ) )
   ::lFStretch            := ( ::LeaDatoLogic( 'WINDOW', "STRETCH", "F" ) == 'T' )
   ::cFParent             := ::LeaDato( 'WINDOW', 'PARENT', '' )
   ::cFParent             := ::LeaDato( 'WINDOW', 'OF', ::cFParent )
   ::cFSubClass           := ::LeaDato( 'WINDOW', 'SUBCLASS', '' )

   ::oDesignForm:Row       := nFRow
   ::oDesignForm:Col       := nFCol
   ::oDesignForm:Width     := nFWidth
   ::oDesignForm:Height    := nFHeight - GetTitleHeight()
   ::oDesignForm:Title     := ::cFTitle
   ::oDesignForm:cFontName := IIF( Empty( ::cFFontName ), _OOHG_DefaultFontName, ::cFFontName )
   ::oDesignForm:nFontSize := IIF( ::nFFontSize > 0, ::nFFontSize, _OOHG_DefaultFontSize )
   ::oDesignForm:FontColor := &( ::cFFontColor )
   ::oDesignForm:BackColor := IIF( IsValidArray( ::cFBackcolor ), &( ::cFBackcolor ), NIL )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pLabel( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cAction, cToolTip, lBorder
LOCAL lClientEdge, lVisible, lEnabled, lTrans, nHelpId, aBackColor, cValue
LOCAL cFontName, nFontSize, aFontColor, lBold, lItalic, lUnderline, lStrikeout
LOCAL lRightAlign, lCenterAlign, lAutoSize, cInputMask, lHScroll, lVScroll
LOCAL lRTL, lNoWrap, lNoPrefix, cSubClass

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '24' ) )
   cAction      := ::LeaDato( cName, 'ACTION', "" )
   cAction      := ::LeaDato( cName, 'ON CLICK',cAction )
   cAction      := ::LeaDato( cName, 'ONCLICK', cAction )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   lBorder      := ( ::LeaDatoLogic( cName, "BORDER", "F" ) == "T" )
   lClientEdge  := ( ::LeaDatoLogic( cName, "CLIENTEDGE", "F") == "T" )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper(  ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper(  ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lTrans       := ( ::LeaDatoLogic( cName, "TRANSPARENT", "F" ) == "T" )
   nHelpId      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   aBackColor   := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   cValue       := ::Clean( ::LeaDato( cName, 'VALUE', '' ) )
   cFontName    := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   aFontColor   := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   lRightAlign  := ( ::LeaDatoLogic( cName, "RIGHTALIGN", "F" ) == "T" )
   lCenterAlign := ( ::LeaDatoLogic( cName, "CENTERALIGN", "F" ) == "T" )
   lAutoSize    := ( ::LeaDatoLogic( cName, "AUTOSIZE", "F" ) == "T" )
   cInputMask   := ::LeaDato( cName, 'INPUTMASK', "" )
   lHScroll     := ( ::LeaDatoLogic( cName, "HSCROLL", "F" ) == "T" )
   lVScroll     := ( ::LeaDatoLogic( cName, "VSCROLL", "F" ) == "T" )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lNoWrap      := ( ::LeaDatoLogic( cName, 'NOWORDWRAP', "F" ) == "T" )
   lNoPrefix    := ( ::LeaDatoLogic( cName, 'NOPREFIX', "F" ) == "T" )
   cSubClass    := ::LeaDato( cName, 'SUBCLASS', '' )

   // Show control
   IF lTrans
      IF lRightAlign
         @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
            WIDTH nWidth ;
            HEIGHT nHeight ;
            VALUE cValue ;
            RIGHTALIGN ;
            TRANSPARENT ;
            ACTION ::Dibuja( This:Name )
      ELSE
         IF lCenterAlign
            @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
               WIDTH nWidth ;
               HEIGHT nHeight ;
               VALUE cValue ;
               CENTERALIGN ;
               TRANSPARENT ;
               ACTION ::Dibuja( This:Name )
         ELSE
            @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
               WIDTH nWidth ;
               HEIGHT nHeight ;
               VALUE cValue ;
               TRANSPARENT ;
               ACTION ::Dibuja( This:Name )
         ENDIF
      ENDIF
   ELSE
      IF lRightAlign
         @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
            WIDTH nWidth ;
            HEIGHT nHeight ;
            VALUE cValue ;
            RIGHTALIGN ;
            ACTION ::Dibuja( This:Name )
      ELSE
         IF lCenterAlign
            @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
               WIDTH nWidth ;
               HEIGHT nHeight ;
               VALUE cValue ;
               CENTERALIGN ;
               ACTION ::Dibuja( This:Name )
         ELSE
            @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
               WIDTH nWidth ;
               HEIGHT nHeight ;
               VALUE cValue ;
               ACTION ::Dibuja( This:Name )
         ENDIF
      ENDIF
   ENDIF
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]      := 'LABEL'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aAction[i]        := cAction
   ::aToolTip[i]       := cToolTip
   ::aBorder[i]        := lBorder
   ::aClientEdge[i]    := lClientEdge
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aTransparent[i]   := lTrans
   ::aHelpID[i]        := nHelpid
   ::aBackColor[i]     := aBackColor
   ::aValue[i]         := cValue
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aRightAlign[i]    := lRightAlign
   ::aCenterAlign[i]   := lCenterAlign
   ::aAutoPlay[i]      := lAutoSize
   ::aInputMask[i]     := cInputMask
   ::aNoHScroll[i]     := lHScroll
   ::aNoVScroll[i]     := lVScroll
   ::aRTL[i]           := lRTL
   ::aWrap[i]          := lNoWrap
   ::aNoPrefix[i]      := lNoPrefix
   ::aSubClass[i]      := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pPlayer( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, nHelpId, cFile, lNoTabStop
LOCAL lVisible, lEnabled, lRTL, lNoAutoSizeW, lNoAutoSizeM, lNoErrorDlg, lNoMenu
LOCAL lNoOpen, lNoPlayBar, lShowAll, lShowMode, lShowName, lShowPosition
LOCAL cSubClass

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::LeaDato( cName, 'OBJ', '' )
   nRow          := Val( ::LeaRow( cName ) )
   nCol          := Val( ::LeaCol( cName ) )
   nWidth        := Val( ::LeaDato( cName, 'WIDTH', '0' ) )
   nHeight       := Val( ::LeaDato( cName, 'HEIGHT', '0' ) )
   nHelpId       := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   cFile         := ::Clean( ::LeaDato( cName, 'FILE', '' ) )
   lNoTabStop    := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )
   lVisible      := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper(  ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper(  ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL          := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lNoAutoSizeW  := ( ::LeaDatoLogic( cName, 'NOAUTOSIZEWINDOW', "F" ) == "T" )
   lNoAutoSizeM  := ( ::LeaDatoLogic( cName, 'NOAUTOSIZEMOVIE', "F" ) == "T" )
   lNoErrorDlg   := ( ::LeaDatoLogic( cName, 'NOERRORDLG', "F" ) == "T" )
   lNoMenu       := ( ::LeaDatoLogic( cName, 'NOMENU', "F" ) == "T" )
   lNoOpen       := ( ::LeaDatoLogic( cName, 'NOOPEN', "F" ) == "T" )
   lNoPlayBar    := ( ::LeaDatoLogic( cName, 'NOPLAYBAR', "F" ) == "T" )
   lShowAll      := ( ::LeaDatoLogic( cName, 'SHOWALL', "F" ) == "T" )
   lShowMode     := ( ::LeaDatoLogic( cName, 'SHOWMODE', "F" ) == "T" )
   lShowName     := ( ::LeaDatoLogic( cName, 'SHOWNAME', "F" ) == "T" )
   lShowPosition := ( ::LeaDatoLogic( cName, 'SHOWPOSITION', "F" ) == "T" )
   cSubClass     := ::LeaDato( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]         := 'PLAYER'
   ::aName[i]             := cName
   ::aCObj[i]             := cObj
   ::aHelpID[i]           := nHelpid
   ::aFile[i]             := cFile
   ::aNoTabStop[i]        := lNoTabStop
   ::aVisible[i]          := lVisible
   ::aEnabled[i]          := lEnabled
   ::aRTL[i]              := lRTL
   ::aNoAutoSizeWindow[i] := lNoAutoSizeW
   ::aNoAutoSizeMovie[i]  := lNoAutoSizeM
   ::aNoErrorDlg[i]       := lNoErrorDlg
   ::aNoMenu[i]           := lNoMenu
   ::aNoOpen[i]           := lNoOpen
   ::aNoPlayBar[i]        := lNoPlayBar
   ::aShowAll[i]          := lShowAll
   ::aShowMode[i]         := lShowMode
   ::aShowName[i]         := lShowName
   ::aShowPosition[i]     := lShowPosition
   ::aSubClass[i]         := cSubClass

   // Show control
   @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE cName ;
      BORDER ;
      ACTION ::Dibuja( This:Name )

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pSpinner( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cRange, nValue, cFontName
LOCAL nFontSize, cToolTip, cOnChange, cOnGotfocus, cOnLostfocus, nHelpId
LOCAL lNoTabStop, lRTL, lWrap, lReadOnly, nIncrement, lVisible, lEnabled
LOCAL aBackColor, aFontColor, lBold, lItalic, lUnderline, lStrikeout, lNoBorder

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '24' ) )
   cRange       := ::LeaDato( cName, 'RANGE', '1, 10' )
   nValue       := Val( ::LeaDato( cName, 'VALUE', '0' ) )
   cFontName    := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnChange    := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnGotfocus  := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostfocus := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   nHelpId      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lNoTabStop   := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lWrap        := ( ::LeaDatoLogic( cName, 'WRAP', "F" ) == "T" )
   lReadOnly    := ( ::LeaDatoLogic( cName, 'READONLY', "F" ) == "T" )
   nIncrement   := Val( ::LeaDato( cName, 'INCREMENT', '0' ) )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper(  ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper(  ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor   := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   lNoBorder    := ( ::LeaDatoLogic( cName, "NOBORDER", "F" ) == "T" )

   // Save properties
   ::aCtrlType[i]      := 'SPINNER'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aRange[i]         := cRange
   ::aValueN[i]        := nValue
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aToolTip[i]       := cToolTip
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotfocus
   ::aOnLostFocus[i]   := cOnLostfocus
   ::aHelpID[i]        := nHelpId
   ::aNoTabStop[i]     := lNoTabStop
   ::aRTL[i]           := lRTL
   ::aWrap[i]          := lWrap
   ::aReadOnly[i]      := lReadOnly
   ::aIncrement[i]     := nIncrement
   ::aEnabled[i]       := lEnabled
   ::aVisible[i]       := lVisible
   ::aBackColor[i]     := aBackColor
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderLine
   ::aFontStrikeout[i] := lStrikeout
   ::aBorder[i]        := lNoBorder

   // Show control
   @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      VALUE cName ;
      ACTION ::Dibuja( This:Name ) ;
      BACKCOLOR WHITE ;
      CLIENTEDGE ;
      VSCROLL
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderLine
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pSlider( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cRange, nValue, cToolTip
LOCAL cOnChange, lVertical, lNoTicks, lBoth, lTop, lLeft, nHelpId, aBackColor
LOCAL lVisible, lEnabled, lNoTabStop, lRTL, cSubClass

   // Load properties
   cName      := ::aControlW[i]
   cObj       := ::LeaDato( cName, 'OBJ', '' )
   nRow       := Val( ::LeaRow( cName ) )
   nCol       := Val( ::LeaCol( cName ) )
   nWidth     := Val( ::LeaDato( cName, 'WIDTH', '0' ) )
   nHeight    := Val( ::LeaDato( cName, 'HEIGHT', '0' ) )
   cRange     := ::LeaDato( cName, 'RANGE', '1, 10' )
   nValue     := Val( ::LeaDato( cName, 'VALUE', '0' ) )
   cToolTip   := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnChange  := ::LeaDato( cName, 'ON CHANGE', '' )
   lVertical  := ( ::LeaDatoLogic( cName, 'VERTICAL', 'F' ) == "T" )
   lNoTicks   := ( ::LeaDatoLogic( cName, 'NOTICKS', 'F' ) == "T" )
   lBoth      := ( ::LeaDatoLogic( cName, 'BOTH', 'F' ) == "T" )
   lTop       := ( ::LeaDatoLogic( cName, 'TOP', 'F' ) == "T" )
   lLeft      := ( ::LeaDatoLogic( cName, 'LEFT', 'F' ) == "T" )
   nHelpId    := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   aBackColor := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible   := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible   := ( Upper(  ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled   := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled   := ( Upper(  ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lNoTabStop := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )
   lRTL       := ( ::LeaDatoLogic( cName, 'RTL', 'F' ) == "T" )
   cSubClass  := ::LeaDato( cName, 'SUBCLASS', '' )

   // Show control
   IF lVertical
      @ nRow, nCol SLIDER &cName OF ( ::oDesignForm:Name ) ;
         RANGE 1, 10 ;
         VALUE 5 ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         ON CHANGE ::Dibuja( This:Name ) ;
         VERTICAL
   ELSE
      @ nRow, nCol SLIDER &cName OF ( ::oDesignForm:Name ) ;
         RANGE 1, 10 ;
         VALUE 5 ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         ON CHANGE ::Dibuja( This:Name )
   ENDIF
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]  := 'SLIDER'
   ::aName[i]      := cName
   ::aCObj[i]      := cObj
   ::aRange[i]     := cRange
   ::aValueN[i]    := nValue
   ::aToolTip[i]   := cToolTip
   ::aOnChange[i]  := cOnChange
   ::aVertical[i]  := lVertical
   ::aNoTicks[i]   := lNoTicks
   ::aBoth[i]      := lBoth
   ::aTop[i]       := lTop
   ::aLeft[i]      := lLeft
   ::aHelpID[i]    := nHelpID
   ::aBackColor[i] := aBackColor
   ::aVisible[i]   := lVisible
   ::aEnabled[i]   := lEnabled
   ::aNoTabStop[i] := lNoTabStop
   ::aRTL[i]       := lRTL
   ::aSubClass[i]  := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pProgressbar( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, lVertical, nWidth, nHeight, cRange, cToolTip
LOCAL lSmooth, nHelpId, lVisible, lEnabled, aBackColor, aFontColor, nValue
LOCAL lRTL, nMarquee

   // Load properties
   cName      := ::aControlW[i]
   cObj       := ::LeaDato( cName, 'OBJ', '' )
   nRow       := Val( ::LeaRow( cName ) )
   nCol       := Val( ::LeaCol( cName ) )
   lVertical  := ( ::LeaDatoLogic( cName, 'VERTICAL', 'F' ) == "T" )
   IF lVertical
      nWidth  := Val( ::LeaDato( cName, 'WIDTH', '25' ) )
      nHeight := Val( ::LeaDato( cName, 'HEIGHT', '120' ) )
   ELSE
      nWidth  := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
      nHeight := Val( ::LeaDato( cName, 'HEIGHT', '25' ) )
   ENDIF
   cRange     := ::LeaDato( cName, 'RANGE', '1, 100' )
   cToolTip   := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   lSmooth    := ( ::LeaDatoLogic( cName, 'SMOOTH', 'F' ) == "T" )
   nHelpId    := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lVisible   := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible   := ( Upper(  ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled   := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled   := ( Upper(  ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor := ::LeaDato( cName, 'FORECOLOR', 'NIL' )
   aFontColor := UpperNIL( ::LeaDato_Oop( cName, 'FORECOLOR', aFontColor ) )
   nValue     := Val( ::LeaDato( cName, 'VALUE', '0' ) )
   lRTL       := ( ::LeaDatoLogic( cName, 'RTL', 'F' ) == "T" )
   nMarquee   := Val( ::LeaDato( cName, 'MARQUEE', '0' ) )

   // Show control
   @ nrow,ncol LABEL &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE cName ;
      BORDER ;
      ACTION ::Dibuja( This:Name )
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]  := 'PROGRESSBAR'
   ::aName[i]      := cName
   ::aCObj[i]      := cObj
   ::aVertical[i]  := lVertical
   ::aRange[i]     := cRange
   ::aToolTip[i]   := cToolTip
   ::aSmooth[i]    := lSmooth
   ::aHelpID[i]    := nHelpID
   ::aVisible[i]   := lVisible
   ::aEnabled[i]   := lEnabled
   ::aBackColor[i] := aBackColor
   ::aFontColor[i] := aFontColor
   ::aValueN[i]    := nValue
   ::aRTL[i]       := lRTL
   ::aMarquee[i]   := nMarquee

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pRadiogroup( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nValue, nSpacing, cFontName, nFontSize
LOCAL cToolTip, cOnChange, lTrans, nHelpid, cItems, lVisible, lEnabled, lBold
LOCAL lItalic, lUnderline, lStrikeout, aBackColor, aFontColor, lRTL, lNoTabStop
LOCAL lAutoSize, lVertical, lThemed, cBackground, nOpen, nClose, ki, nItems
LOCAL cSubClass

   // Load properties
   cName       := ::aControlW[i]
   cObj        := ::LeaDato( cName, 'OBJ', '' )
   nRow        := Val( ::LeaRow( cName ) )
   nCol        := Val( ::LeaCol( cName ) )
   nWidth      := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
   nValue      := Val( ::LeaDato( cName, 'VALUE', '0' ) )
   nSpacing    := Val( ::LeaDato( cName, 'SPACING', "25" ) )
   cFontName   := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize   := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   cToolTip    := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnChange   := ::LeaDato( cName, 'ON CHANGE', '' )
   lTrans      := ( ::LeaDatoLogic( cName, "TRANSPARENT", "F" ) == "T" )
   nHelpid     := Val( ::LeaDato(cName, 'HELPID', "0" ) )
   cItems      := ::LeaDato( cName, 'OPTIONS', "{ 'option 1', 'option 2' }" )
   lVisible    := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible    := ( Upper(  ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled    := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled    := ( Upper(  ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lBold       := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold       := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic     := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic     := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline  := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline  := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout  := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout  := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor  := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor  := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor  := ::LeaDato( cName, 'FORECOLOR', 'NIL' )
   aFontColor  := UpperNIL( ::LeaDato_Oop( cName, 'FORECOLOR', aFontColor ) )
   lRTL        := ( ::LeaDatoLogic( cName, 'RTL', 'F' ) == "T" )
   lNoTabStop  := ( ::LeaDatoLogic( cName, "NOTABSTOP", "F" ) == "T" )
   lAutoSize   := ( ::LeaDatoLogic( cName, "AUTOSIZE", "F" ) == "T" )
   lVertical   := ( ::LeaDatoLogic( cName, 'VERTICAL', "F" ) == "T" )
   lThemed     := ( ::LeaDatoLogic( cName, 'THEMED', "F" ) == "T" )
   cBackground := ::LeaDato( cName, 'BACKGROUND', '' )
   cSubClass   := ::LeaDato( cName, 'SUBCLASS', '' )

   nOpen := nClose := 0
   FOR ki := 1 TO Len( cItems )
      IF SubStr( cItems, ki, 1 ) == '{'
         nOpen ++
      ELSEIF SubStr( cItems, ki, 1) == '}'
         nClose ++
      ENDIF
   NEXT ki
   IF nOpen # 1 .OR. nClose # 1 .OR. Len( &cItems ) < 2
      cItems := "{ 'option 1', 'option 2' }"
   ENDIF
   nItems := Len( &cItems )

   // Show control
   IF lTrans
      @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
         WIDTH nWidth ;
         HEIGHT nSpacing * nItems + 8 ;
         VALUE cName ;
         BORDER ;
         TRANSPARENT ;
         ACTION ::Dibuja( This:Name )
   ELSE
      @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
         WIDTH nWidth ;
         HEIGHT nSpacing * nItems + 8 ;
         VALUE cName ;
         BORDER ;
         ACTION ::Dibuja( This:Name )
   ENDIF
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderLine
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   ::oDesignForm:&cName:ToolTip := cToolTip
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF

   // Save properties
   ::aCtrlType[i]      := 'RADIOGROUP'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aValueN[i]        := nValue
   ::aSpacing[i]       := nSpacing
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aToolTip[i]       := cToolTip
   ::aOnChange[i]      := cOnChange
   ::aTransparent[i]   := lTrans
   ::aHelpID[i]        := nHelpID
   ::aItems[i]         := cItems
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderLine
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aFontColor[i]     := aFontColor
   ::aRTL[i]           := lRTL
   ::aNoTabStop[i]     := lNoTabStop
   ::aAutoPlay[i]      := lAutoSize
   ::aVertical[i]      := lVertical
   ::aThemed[i]        := lThemed
   ::aBackground[i]    := cBackground
   ::aSubClass[i]      := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pEditbox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aFontColor
LOCAL lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled
LOCAL cToolTip, cOnChange, cOnGotFocus, cOnLostFocus, cOnVScroll, cOnHScroll
LOCAL nFocusedPos, lNoBorder, lRTL, cValue, cField, nMaxLength, lReadonly
LOCAL lBreak, nHelpID, lNoTabStop, lNoVScroll, lNoHScroll

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '240' ) )
   cFontName    := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   aFontColor   := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnChange    := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnGotFocus  := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   cOnVScroll   := ::LeaDato( cName, 'ON VSCROLL', '' )
   cOnHScroll   := ::LeaDato( cName, 'ON HSCROLL', '' )
   nFocusedPos  := Val( ::LeaDato( cName, 'FOCUSEDPOS', '-4' ) )
   lNoBorder    := ( ::LeaDatoLogic( cName, "NOBORDER", "F" ) == "T" )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   cValue       := ::Clean( ::LeaDato( cName, 'VALUE', '' ) )
   cField       := ::LeaDato( cName, 'FIELD', '' )
   nMaxLength   := Val( ::LeaDato( cName, 'MAXLENGTH', '0' ) )
   lReadonly    := ( ::LeaDatoLogic( cName, "READONLY", "F" ) == "T" )
   lBreak       := ( ::LeaDatoLogic( cName, "BREAK", "F" ) == "T" )
   nHelpID      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lNoTabStop   := ( ::LeaDatoLogic( cName, "NOTABSTOP", "F" ) == "T" )
   lNoVScroll   := ( ::LeaDatoLogic( cName, "NOVSCROLL", "F" ) == "T" )
   lNoHScroll   := ( ::LeaDatoLogic( cName, "NOHSCROLL", "F" ) == "T" )

   // Show control
   @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE cName ;
      BACKCOLOR WHITE ;
      CLIENTEDGE ;
      HSCROLL ;
      VSCROLL ;
      ACTION ::Dibuja( This:Name )
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip
   ::oDesignForm:&cName:Value := cValue

   // Save properties
   ::aCtrlType[i]      := 'EDIT'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cTooltip
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnVScroll[i]     := cOnVScroll
   ::aOnHScroll[i]     := cOnHScroll
   ::aFocusedPos[i]    := nFocusedPos
   ::aBorder[i]        := lNoBorder
   ::aRTL[i]           := lRTL
   ::aValue[i]         := cValue
   ::aField[i]         := cField
   ::aMaxLength[i]     := nMaxLength
   ::aReadOnly[i]      := lReadonly
   ::aBreak[i]         := lBreak
   ::aHelpID[i]        := nHelpID
   ::aNoTabStop[i]     := lNoTabStop
   ::aNoVScroll[i]     := lNoVScroll
   ::aNoHScroll[i]     := lNoHScroll

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pRichedit( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, cValue
LOCAL cField, cToolTip, nMaxLength, lReadonly, lBreak, lNoTabStop, nHelpID
LOCAL cOnChange, cOnGotFocus, cOnLostFocus, lVisible, lEnabled, lBold, lItalic
LOCAL lUnderline, lStrikeout, aFontColor, aBackColor, lRTL, nFocusedPos
LOCAL lNoVScroll, cOnVScroll, cOnHScroll, cFile, cSubClass, cOnSelChange
LOCAL lNoHideSel, lPlainText, nFileType, lNoHScroll

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '240' ) )
   cFontName    := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   cValue       := ::Clean( ::LeaDato( cName, 'VALUE', '' ) )
   cField       := ::LeaDato( cName, 'FIELD', '' )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   nMaxLength   := Val( ::LeaDato( cName, 'MAXLENGTH', '0' ) )
   lReadonly    := ( ::LeaDatoLogic( cName, "READONLY", "F" ) == "T" )
   lBreak       := ( ::LeaDatoLogic( cName, "BREAK", "F" ) == "T" )
   lNoTabStop   := ( ::LeaDatoLogic( cName, "NOTABSTOP", "F" ) == "T" )
   nHelpID      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   cOnChange    := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnGotFocus  := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aFontColor   := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   aBackColor   := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   nFocusedPos  := Val( ::LeaDato( cName, 'FOCUSEDPOS', '-4' ) )
   lNoVScroll   := ( ::LeaDatoLogic( cName, "NOVSCROLL", "F" ) == "T" )
   lNoHScroll   := ( ::LeaDatoLogic( cName, "NOHSCROLL", "F" ) == "T" )
   cOnVScroll   := ::LeaDato( cName, 'ON VSCROLL', '' )
   cOnHScroll   := ::LeaDato( cName, 'ON HSCROLL', '' )
   cFile        := ::Clean( ::LeaDato( cName, 'FILE', '' ) )
   cSubClass    := ::LeaDato( cName, 'SUBCLASS', '' )
   cOnSelChange := ::LeaDato( cName, 'ON SELCHANGE', '' )
   lNoHideSel   := ( ::LeaDatoLogic( cName, "NOHIDESEL", "F" ) == "T" )
   lPlainText   := ( ::LeaDatoLogic( cName, "PLAINTEXT", "F" ) == "T" )
   nFileType    := Val( ::LeaDatoLogic( cName, "FILETYPE", "0" ) )

   // Show control
   @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      VALUE cName ;
      BACKCOLOR WHITE ;
      CLIENTEDGE ;
      HSCROLL ;
      VSCROLL ;
      ACTION ::Dibuja( This:Name )
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip
   ::oDesignForm:&cName:Value := cValue

   // Save properties
   ::aCtrlType[i]      := 'RICHEDIT'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aValue[i]         := cValue
   ::aField[i]         := cField
   ::aToolTip[i]       := cTooltip
   ::aMaxLength[i]     := nMaxLength
   ::aReadOnly[i]      := lReadonly
   ::aBreak[i]         := lBreak
   ::aNoTabStop[i]     := lNoTabStop
   ::aHelpID[i]        := nHelpID
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aFontColor[i]     := aFontColor
   ::aBackColor[i]     := aBackColor
   ::aRTL[i]           := lRTL
   ::aFocusedPos[i]    := nFocusedPos
   ::aNoVScroll[i]     := lNoVScroll
   ::aNoHScroll[i]     := lNoHScroll
   ::aOnVScroll[i]     := cOnVScroll
   ::aOnHScroll[i]     := cOnHScroll
   ::aFile[i]          := cFile
   ::aSubClass[i]      := cSubClass
   ::aOnSelChange[i]   := cOnSelChange
   ::aNoHideSel[i]     := lNoHideSel
   ::aPlainText[i]     := lPlainText
   ::aFileType[i]      := nFileType

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pFrame( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cCaption, lOpaque, lTrans
LOCAL cFontName, nFontSize, aFontColor, lBold, lItalic, lUnderline, lStrikeout
LOCAL aBackColor, lVisible, lEnabled, lRTL, cSubClass

   // Load properties
   cName      := ::aControlW[i]
   cObj       := ::LeaDato( cName, 'OBJ', '' )
   nRow       := Val( ::LeaRow( cName ) )
   nCol       := Val( ::LeaCol( cName ) )
   nWidth     := Val( ::LeaDato( cName, 'WIDTH', '140' ) )
   nHeight    := Val( ::LeaDato( cName, 'HEIGHT', '140' ) )
   cCaption   := ::Clean( ::LeaDato( cName, 'CAPTION', cName ) )
   lOpaque    := ( ::LeaDatoLogic( cName, "OPAQUE", "F") == "T" )
   lTrans     := ( ::LeaDatoLogic( cName, "TRANSPARENT", "F" ) == "T" )
   cFontName  := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize  := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   aFontColor := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lBold      := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold      := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic    := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic    := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible   := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible   := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled   := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled   := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL       := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   cSubClass  := ::LeaDato( cName, 'SUBCLASS', '' )

   IF lOpaque
      @ nRow, nCol FRAME &cName OF ( ::oDesignForm:Name ) ;
         CAPTION cCaption ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         OPAQUE
   ELSE
      @ nRow, nCol FRAME &cName OF ( ::oDesignForm:Name ) ;
         CAPTION cCaption ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         TRANSPARENT
   ENDIF
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF

   ::aCtrlType[i]      := 'FRAME'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aCaption[i]       := cCaption
   ::aTransparent[i]   := lTrans
   ::aOpaque[i]        := lOpaque
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aRTL[i]           := lRTL
   ::aSubClass[i]      := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pBrowse( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cHeaders, cWidths, cWorkArea
LOCAL cFields, nValue, cFontName, nFontSize, cToolTip, cInputMask, cDynBackColor
LOCAL cDynForecolor, cColControls, cOnChange, cOnGotFocus, cOnLostFocus
LOCAL cOnDblClick, cOnEnter, cOnHeadClick, cOnEditCell, cOnAppend, cWhen, cValid
LOCAL cValidMess, cReadOnly, lLock, lDelete, lAppend, lInPlace, lEdit, lNoLines
LOCAL cImage, cJustify, nHelpId, lBold, lItalic, lUnderline, lStrikeout
LOCAL aBackColor, aFontColor, cAction, lBreak, lRTL, lNoTabStop, lVisible
LOCAL lEnabled, lFull, lButtons, lNoHeaders, cHeaderImages, cImagesAlign
LOCAL aSelColor, cEditKeys, lDoubleBuffer, lSingleBuffer, lFocusRect
LOCAL lNoFocusRect, lPLM, lFixedCols, cOnAbortEdit, lFixedWidths, cBeforeColMove
LOCAL cAfterColMove, cBeforeColSize, cAfterColSize, cBeforeAutoFit, lLikeExcel
LOCAL cDeleteWhen, cDeleteMsg, cOnDelete, lNoDeleteMsg, lFixedCtrls
LOCAL lDynamicCtrls, cOnHeadRClick, lExtDblClick, lNoVScroll, lNoRefresh
LOCAL cReplaceField, cSubClass, lRecCount, cColumnInfo, lDescending
LOCAL lForceRefresh, lSync, lUnSync, lUpdateAll, lFixedBlocks, lDynamicBlocks
LOCAL lUpdateColors

   // Load properties
   cName          := ::aControlW[i]
   cObj           := ::LeaDato( cName, 'OBJ', '' )
   nRow           := Val( ::LeaRow( cName ) )
   nCol           := Val( ::LeaCol( cName ) )
   nWidth         := Val( ::LeaDato( cName, 'WIDTH', '240' ) )              // use control's default value
   nHeight        := Val( ::LeaDato( cName, 'HEIGHT', '120' ) )              // use control's default value
   cHeaders       := ::LeaDato( cName, 'HEADERS', "{ '','' } ")
   cWidths        := ::LeaDato( cName, 'WIDTHS', "{ 100, 60 }")
   cWorkArea      := ::LeaDato( cName, 'WORKAREA', "ALIAS()" )
   cFields        := ::LeaDato( cName, 'FIELDS', "{ 'field1', 'field2' }" )
   nValue         := Val( ::LeaDato( cName, 'VALUE', '' ) )
   cFontName      := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize      := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   cToolTip       := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cInputMask     := ::LeaDato( cName, 'INPUTMASK', "")
   cDynBackColor  := ::LeaDato( cName, "DYNAMICBACKCOLOR", '' )
   cDynForecolor  := ::LeaDato( cName, "DYNAMICFORECOLOR", '' )
   cColControls   := ::LeaDato( cName, "COLUMNCONTROLS", "" )
   cOnChange      := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnGotFocus    := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus   := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   cOnDblClick    := ::LeaDato( cName, 'ON DBLCLICK', '' )
   cOnEnter       := ::LeaDato( cName, 'ON ENTER', '' )
   cOnHeadClick   := ::LeaDato( cName, 'ON HEADCLICK', '' )
   cOnEditCell    := ::LeaDato( cName, 'ON EDITCELL', '' )
   cOnAppend      := ::LeaDato( cName, 'ON APPEND', '' )
   cWhen          := ::LeaDato( cName, 'WHEN', "" )
   cWhen          := ::LeaDato( cName, 'COLUMNWHEN', cWhen )
   cValid         := ::LeaDato( cName, 'VALID', "" )
   cValidMess     := ::LeaDato( cName, 'VALIDMESSAGES', "" )
   cReadOnly      := ::LeaDato( cName, 'READONLY', "")
   lLock          := ( ::LeaDatoLogic( cName, 'LOCK', "F" ) == "T" )
   lDelete        := ( ::LeaDatoLogic( cName, 'DELETE', "F" ) == "T" )
   lAppend        := ( ::LeaDatoLogic( cName, 'APPEND', "F" ) == "T" )
   lInPlace       := ( ::LeaDatoLogic( cName, 'INPLACE', "F" ) == "T" )
   lEdit          := ( ::LeaDatoLogic( cName, 'EDIT', "F" ) == "T" )
   lNoLines       := ( ::LeaDatoLogic( cName, 'NOLINES', "F" ) == "T" )
   cImage         := ::LeaDato( cName, 'IMAGE', "" )
   cJustify       := ::LeaDato( cName, 'JUSTIFY', "" )
   nHelpId        := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lBold          := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold          := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic        := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic        := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline     := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline     := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout     := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout     := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor     := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor     := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor     := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor     := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   cAction        := ::LeaDato( cName, 'ACTION', "" )
   cAction        := ::LeaDato( cName, 'ON CLICK',cAction )
   cAction        := ::LeaDato( cName, 'ONCLICK', cAction )
   lBreak         := ( ::LeaDatoLogic( cName, "BREAK", "F" ) == "T" )
   lRTL           := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lNoTabStop     := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )
   lVisible       := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible       := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled       := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled       := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lFull          := ( ::LeaDatoLogic( cName, 'FULLMOVE', "F" ) == "T" )
   lButtons       := ( ::LeaDatoLogic( cName, 'USEBUTTONS', "F" ) == "T" )
   lNoHeaders     := ( ::LeaDatoLogic( cName, 'NOHEADERS', "F" ) == "T" )
   cHeaderImages  := ::LeaDato( cName, 'HEADERIMAGES', '' )
   cImagesAlign   := ::LeaDato( cName, 'IMAGESALIGN', '' )
   aSelColor      := UpperNIL( ::LeaDato( cName, 'SELECTEDCOLORS', '' ) )
   cEditKeys      := ::LeaDato( cName, 'EDITKEYS', '' )
   lDoubleBuffer  := ( ::LeaDatoLogic( cName, 'DOUBLEBUFFER', "F" ) == "T" )
   lSingleBuffer  := ( ::LeaDatoLogic( cName, 'SINGLEBUFFER', "F" ) == "T" )
   lFocusRect     := ( ::LeaDatoLogic( cName, 'FOCUSRECT', "F" ) == "T" )
   lNoFocusRect   := ( ::LeaDatoLogic( cName, 'NOFOCUSRECT', "F" ) == "T" )
   lPLM           := ( ::LeaDatoLogic( cName, 'PAINTLEFTMARGIN', "F" ) == "T" )
   lFixedCols     := ( ::LeaDatoLogic( cName, 'FIXEDCOLS', "F" ) == "T" )
   cOnAbortEdit   := ::LeaDato( cName, 'ON ABORTEDIT', '' )
   lFixedWidths   := ( ::LeaDatoLogic( cName, 'FIXEDWIDTHS', "F" ) == "T" )
   cBeforeColMove := ::LeaDato( cName, 'BEFORECOLMOVE', '' )
   cAfterColMove  := ::LeaDato( cName, 'AFTERCOLMOVE', '' )
   cBeforeColSize := ::LeaDato( cName, 'BEFORECOLSIZE', '' )
   cAfterColSize  := ::LeaDato( cName, 'AFTERCOLSIZE', '' )
   cBeforeAutoFit := ::LeaDato( cName, 'BEFOREAUTOFIT', '' )
   lLikeExcel     := ( ::LeaDatoLogic( cName, 'EDITLIKEEXCEL', "F" ) == "T" )
   cDeleteWhen    := ::LeaDato( cName, 'DELETEWHEN', '' )
   cDeleteMsg     := ::LeaDato( cName, 'DELETEMSG', '' )
   cOnDelete      := ::LeaDato( cName, 'ON DELETE', '' )
   lNoDeleteMsg   := ( ::LeaDatoLogic( cName, 'NODELETEMSG', "F" ) == "T" )
   lFixedCtrls    := ( ::LeaDatoLogic( cName, 'FIXEDCONTROLS', "F" ) == "T" )
   lDynamicCtrls  := ( ::LeaDatoLogic( cName, 'DYNAMICCONTROLS', "F" ) == "T" )
   cOnHeadRClick  := ::LeaDato( cName, 'ON HEADRCLICK', '' )
   lExtDblClick   := ( ::LeaDatoLogic( cName, 'EXTDBLCLICK', "F" ) == "T" )
   lNoVScroll     := ( ::LeaDatoLogic( cName, "NOVSCROLL", "F" ) == "T" )
   lNoRefresh     := ( ::LeaDatoLogic( cName, "NOREFRESH", "F" ) == "T" )
   cReplaceField  := ::LeaDato( cName, 'REPLACEFIELD', '' )
   cSubClass      := ::LeaDato( cName, 'SUBCLASS', '' )
   lRecCount      := ( ::LeaDatoLogic( cName, "RECCOUNT", "F" ) == "T" )
   cColumnInfo    := ::LeaDato( cName, 'COLUMNINFO', '' )
   lDescending    := ( ::LeaDatoLogic( cName, "DESCENDING", "F" ) == "T" )
   lForceRefresh  := ( ::LeaDatoLogic( cName, "FORCEREFRESH", "F" ) == "T" )
   lSync          := ( ::LeaDatoLogic( cName, "SYNCHRONIZED", "F" ) == "T" )
   lUnSync        := ( ::LeaDatoLogic( cName, "UNSYNCHRONIZED", "F" ) == "T" )
   lUpdateAll     := ( ::LeaDatoLogic( cName, "UPDATEALL", "F" ) == "T" )
   lFixedBlocks   := ( ::LeaDatoLogic( cName, "FIXEDBLOCKS", "F" ) == "T" )
   lDynamicBlocks := ( ::LeaDatoLogic( cName, "DYNAMICBLOCKS", "F" ) == "T" )
   lUpdateColors  := ( ::LeaDatoLogic( cName, "UPDATECOLORS", "F" ) == "T" )

   // Show control
   @ nRow, nCol GRID &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      HEADERS { cName, '' } ;
      WIDTHS { 100, 60 } ;
      ITEMS { { "", "" } } ;
      TOOLTIP 'To change properties and events right click on header area' ;
      ON GOTFOCUS ::Dibuja( This:Name ) ;
      ON CHANGE ::Dibuja( This:Name )
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]         := 'BROWSE'
   ::aName[i]             := cName
   ::aCObj[i]             := cObj
   ::aHeaders[i]          := cHeaders
   ::aWidths[i]           := cWidths
   ::aWorkArea[i]         := cWorkArea
   ::aFields[i]           := cFields
   ::aValueN[i]           := nValue
   ::aFontName[i]         := cFontName
   ::aFontSize[i]         := nFontSize
   ::aToolTip[i]          := cToolTip
   ::aInputMask[i]        := cInputMask
   ::aDynamicBackColor[i] := cDynBackColor
   ::aDynamicForeColor[i] := cDynForecolor
   ::aColumnControls[i]   := cColControls
   ::aOnChange[i]         := cOnChange
   ::aOnGotFocus[i]       := cOnGotFocus
   ::aOnLostFocus[i]      := cOnLostFocus
   ::aOnDblClick[i]       := cOnDblClick
   ::aOnEnter[i]          := cOnEnter
   ::aOnHeadClick[i]      := cOnHeadClick
   ::aOnEditCell[i]       := cOnEditCell
   ::aOnAppend[i]         := cOnAppend
   ::aWhen[i]             := cWhen
   ::aValid[i]            := cValid
   ::aValidMess[i]        := cValidMess
   ::aReadOnlyB[i]        := cReadOnly
   ::aLock[i]             := lLock
   ::aDelete[i]           := lDelete
   ::aAppend[i]           := lAppend
   ::aInPlace[i]          := lInPlace
   ::aEdit[i]             := lEdit
   ::aNoLines[i]          := lNoLines
   ::aImage[i]            := cImage
   ::aJustify[i]          := cJustify
   ::aHelpID[i]           := nHelpId
   ::aBold[i]             := lBold
   ::aFontItalic[i]       := lItalic
   ::aFontUnderline[i]    := lUnderline
   ::aFontStrikeout[i]    := lStrikeout
   ::aBackColor[i]        := aBackColor
   ::aFontColor[i]        := aFontColor
   ::aAction[i]           := cAction
   ::aBreak[i]            := lBreak
   ::aRTL[i]              := lRTL
   ::aNoTabStop[i]        := lNoTabStop
   ::aVisible[i]          := lVisible
   ::aEnabled[i]          := lEnabled
   ::aFull[i]             := lFull
   ::aButtons[i]          := lButtons
   ::aNoHeaders[i]        := lNoHeaders
   ::aHeaderImages[i]     := cHeaderImages
   ::aImagesAlign[i]      := cImagesAlign
   ::aSelColor[i]         := aSelColor
   ::aEditKeys[i]         := cEditKeys
   ::aDoubleBuffer[i]     := lDoubleBuffer
   ::aSingleBuffer[i]     := lSingleBuffer
   ::aFocusRect[i]        := lFocusRect
   ::aNoFocusRect[i]      := lNoFocusRect
   ::aPLM[i]              := lPLM
   ::aFixedCols[i]        := lFixedCols
   ::aOnAbortEdit[i]      := cOnAbortEdit
   ::aFixedWidths[i]      := lFixedWidths
   ::aBeforeColMove[i]    := cBeforeColMove
   ::aAfterColMove[i]     := cAfterColMove
   ::aBeforeColSize[i]    := cBeforeColSize
   ::aAfterColSize[i]     := cAfterColSize
   ::aBeforeAutoFit[i]    := cBeforeAutoFit
   ::aLikeExcel[i]        := lLikeExcel
   ::aDeleteWhen[i]       := cDeleteWhen
   ::aDeleteMsg[i]        := cDeleteMsg
   ::aOnDelete[i]         := cOnDelete
   ::aNoDelMsg[i]         := lNoDeleteMsg
   ::aFixedCtrls[i]       := lFixedCtrls
   ::aDynamicCtrls[i]     := lDynamicCtrls
   ::aOnHeadRClick[i]     := cOnHeadRClick
   ::aExtDblClick[i]      := lExtDblClick
   ::aNoVScroll[i]        := lNoVScroll
   ::aNoRefresh[i]        := lNoRefresh
   ::aReplaceField[i]     := cReplaceField
   ::aSubClass[i]         := cSubClass
   ::aRecCount[i]         := lRecCount
   ::aColumnInfo[i]       := cColumnInfo
   ::aDescend[i]          := lDescending
   ::aForceRefresh[i]     := lForceRefresh
   ::aSync[i]             := lSync
   ::aUnSync[i]           := lUnSync
   ::aUpdate[i]           := lUpdateAll
   ::aFixBlocks[i]        := lFixedBlocks
   ::aDynBlocks[i]        := lDynamicBlocks
   ::aUpdateColors[i]     := lUpdateColors

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pXBrowse( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cHeaders, cWidths, cWorkArea
LOCAL cFields, cInputMask, nValue, cFontName, nFontSize, lBold, lItalic
LOCAL lUnderline, lStrikeout, cToolTip, aBackColor, cDynBackColor, cDynForecolor
LOCAL aFontColor, cOnGotFocus, cOnChange, cOnLostFocus, cOnDblClick, cAction
LOCAL lEdit, lInPlace, lAppend, cOnHeadClick, cWhen, cValid, cValidMess
LOCAL cReadOnly, lLock, lDelete, lNoLines, cImage, cJustify, lNoVScroll, nHelpId
LOCAL lBreak, lRTL, cOnAppend, cOnEditCell, cColControls, cReplaceField
LOCAL cSubClass, lRecCount, cColumnInfo, lNoHeaders, cOnEnter, lEnabled
LOCAL lNoTabStop, lVisible, lDescending, cDeleteWhen, cDeleteMsg, cOnDelete
LOCAL cHeaderImages, cImagesAlign, lFull, aSelColor, cEditKeys, lDoubleBuffer
LOCAL lSingleBuffer, lFocusRect, lNoFocusRect, lPLM, lFixedCols, cOnAbortEdit
LOCAL lFixedWidths, lFixedBlocks, lDynamicBlocks, cBeforeColMove, cAfterColMove
LOCAL cBeforeColSize, cAfterColSize, cBeforeAutoFit, lLikeExcel, lButtons
LOCAL lNoDeleteMsg, lFixedCtrls, lDynamicCtrls, lNoShowEmpty, lUpdateColors
LOCAL cOnHeadRClick, lNoModalEdit, lByCell, lExtDblClick

   // Load properties
   cName          := ::aControlW[i]
   cObj           := ::LeaDato( cName, 'OBJ', '' )
   nRow           := Val( ::LeaRow( cName ) )
   nCol           := Val( ::LeaCol( cName ) )
   nWidth         := Val( ::LeaDato( cName, 'WIDTH', '240' ) )              // use control's default value
   nHeight        := Val( ::LeaDato( cName, 'HEIGHT', '120' ) )              // use control's default value
   cHeaders       := ::LeaDato( cName, 'HEADERS', "{ '','' } ")
   cWidths        := ::LeaDato( cName, 'WIDTHS', "{ 100, 60 }")
   cWorkArea      := ::LeaDato( cName, 'WORKAREA', "ALIAS()" )
   cFields        := ::LeaDato( cName, 'FIELDS', "{ 'field1', 'field2' }" )
   cInputMask     := ::LeaDato( cName, 'INPUTMASK', "")
   nValue         := Val( ::LeaDato( cName, 'VALUE', '' ) )
   cFontName      := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize      := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   lBold          := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold          := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic        := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic        := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline     := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline     := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout     := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout     := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip       := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   aBackColor     := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor     := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   cDynBackColor  := ::LeaDato( cName, "DYNAMICBACKCOLOR", '' )
   cDynForecolor  := ::LeaDato( cName, "DYNAMICFORECOLOR", '' )
   aFontColor     := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor     := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   cOnGotFocus    := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnChange      := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnLostFocus   := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   cOnDblClick    := ::LeaDato( cName, 'ON DBLCLICK', '' )
   cAction        := ::LeaDato( cName, 'ACTION', "" )
   cAction        := ::LeaDato( cName, 'ON CLICK',cAction )
   cAction        := ::LeaDato( cName, 'ONCLICK', cAction )
   lEdit          := ( ::LeaDatoLogic( cName, 'EDIT', "F" ) == "T" )
   lInPlace       := ( ::LeaDatoLogic( cName, 'INPLACE', "F" ) == "T" )
   lAppend        := ( ::LeaDatoLogic( cName, 'APPEND', "F" ) == "T" )
   cOnHeadClick   := ::LeaDato( cName, 'ON HEADCLICK', '' )
   cWhen          := ::LeaDato( cName, 'WHEN', "" )
   cWhen          := ::LeaDato( cName, 'COLUMNWHEN', cWhen )
   cValid         := ::LeaDato( cName, 'VALID', "" )
   cValidMess     := ::LeaDato( cName, 'VALIDMESSAGES', "" )
   cReadOnly      := ::LeaDato( cName, 'READONLY', "")
   lLock          := ( ::LeaDatoLogic( cName, 'LOCK', "F" ) == "T" )
   lDelete        := ( ::LeaDatoLogic( cName, 'DELETE', "F" ) == "T" )
   lNoLines       := ( ::LeaDatoLogic( cName, 'NOLINES', "F" ) == "T" )
   cImage         := ::LeaDato( cName, 'IMAGE', "" )
   cJustify       := ::LeaDato( cName, 'JUSTIFY', "" )
   lNoVScroll     := ( ::LeaDatoLogic( cName, "NOVSCROLL", "F" ) == "T" )
   nHelpId        := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lBreak         := ( ::LeaDatoLogic( cName, "BREAK", "F" ) == "T" )
   lRTL           := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   cOnAppend      := ::LeaDato( cName, 'ON APPEND', '' )
   cOnEditCell    := ::LeaDato( cName, 'ON EDITCELL', '' )
   cColControls   := ::LeaDato( cName, "COLUMNCONTROLS", "" )
   cReplaceField  := ::LeaDato( cName, 'REPLACEFIELD', '' )
   cSubClass      := ::LeaDato( cName, 'SUBCLASS', '' )
   lRecCount      := ( ::LeaDatoLogic( cName, "RECCOUNT", "F" ) == "T" )
   cColumnInfo    := ::LeaDato( cName, 'COLUMNINFO', '' )
   lNoHeaders     := ( ::LeaDatoLogic( cName, 'NOHEADERS', "F" ) == "T" )
   cOnEnter       := ::LeaDato( cName, 'ON ENTER', '' )
   lEnabled       := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled       := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lNoTabStop     := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )
   lVisible       := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible       := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lDescending    := ( ::LeaDatoLogic( cName, "DESCENDING", "F" ) == "T" )
   cDeleteWhen    := ::LeaDato( cName, 'DELETEWHEN', '' )
   cDeleteMsg     := ::LeaDato( cName, 'DELETEMSG', '' )
   cOnDelete      := ::LeaDato( cName, 'ON DELETE', '' )
   cHeaderImages  := ::LeaDato( cName, 'HEADERIMAGES', '' )
   cImagesAlign   := ::LeaDato( cName, 'IMAGESALIGN', '' )
   lFull          := ( ::LeaDatoLogic( cName, 'FULLMOVE', "F" ) == "T" )
   aSelColor      := UpperNIL( ::LeaDato( cName, 'SELECTEDCOLORS', '' ) )
   cEditKeys      := ::LeaDato( cName, 'EDITKEYS', '' )
   lDoubleBuffer  := ( ::LeaDatoLogic( cName, 'DOUBLEBUFFER', "F" ) == "T" )
   lSingleBuffer  := ( ::LeaDatoLogic( cName, 'SINGLEBUFFER', "F" ) == "T" )
   lFocusRect     := ( ::LeaDatoLogic( cName, 'FOCUSRECT', "F" ) == "T" )
   lNoFocusRect   := ( ::LeaDatoLogic( cName, 'NOFOCUSRECT', "F" ) == "T" )
   lPLM           := ( ::LeaDatoLogic( cName, 'PAINTLEFTMARGIN', "F" ) == "T" )
   lFixedCols     := ( ::LeaDatoLogic( cName, 'FIXEDCOLS', "F" ) == "T" )
   cOnAbortEdit   := ::LeaDato( cName, 'ON ABORTEDIT', '' )
   lFixedWidths   := ( ::LeaDatoLogic( cName, 'FIXEDWIDTHS', "F" ) == "T" )
   lFixedBlocks   := ( ::LeaDatoLogic( cName, "FIXEDBLOCKS", "F" ) == "T" )
   lDynamicBlocks := ( ::LeaDatoLogic( cName, "DYNAMICBLOCKS", "F" ) == "T" )
   cBeforeColMove := ::LeaDato( cName, 'BEFORECOLMOVE', '' )
   cAfterColMove  := ::LeaDato( cName, 'AFTERCOLMOVE', '' )
   cBeforeColSize := ::LeaDato( cName, 'BEFORECOLSIZE', '' )
   cAfterColSize  := ::LeaDato( cName, 'AFTERCOLSIZE', '' )
   cBeforeAutoFit := ::LeaDato( cName, 'BEFOREAUTOFIT', '' )
   lLikeExcel     := ( ::LeaDatoLogic( cName, 'EDITLIKEEXCEL', "F" ) == "T" )
   lButtons       := ( ::LeaDatoLogic( cName, 'USEBUTTONS', "F" ) == "T" )
   lNoDeleteMsg   := ( ::LeaDatoLogic( cName, 'NODELETEMSG', "F" ) == "T" )
   lFixedCtrls    := ( ::LeaDatoLogic( cName, 'FIXEDCONTROLS', "F" ) == "T" )
   lDynamicCtrls  := ( ::LeaDatoLogic( cName, 'DYNAMICCONTROLS', "F" ) == "T" )
   lNoShowEmpty   := ( ::LeaDatoLogic( cName, 'NOSHOWEMPTYROW', "F" ) == "T" )
   lUpdateColors  := ( ::LeaDatoLogic( cName, "UPDATECOLORS", "F" ) == "T" )
   cOnHeadRClick  := ::LeaDato( cName, 'ON HEADRCLICK', '' )
   lNoModalEdit   := ( ::LeaDatoLogic( cName, 'NOMODALEDIT', "F" ) == "T" )
   lByCell        := ( ::LeaDatoLogic( cName, 'NAVIGATEBYCELL', "F" ) == "T" )
   lExtDblClick   := ( ::LeaDatoLogic( cName, 'EXTDBLCLICK', "F" ) == "T" )

   // Show control
   @ nRow, nCol GRID &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      HEADERS { cName, '' } ;
      WIDTHS { 100, 60 } ;
      ITEMS { { "", "" } } ;
      TOOLTIP 'To change properties and events right click on header area' ;
      ON GOTFOCUS ::Dibuja( This:Name ) ;
      ON CHANGE ::Dibuja( This:Name )
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]         := 'XBROWSE'
   ::aName[i]             := cName
   ::aCObj[i]             := cObj
   ::aHeaders[i]          := cHeaders
   ::aWidths[i]           := cWidths
   ::aWorkArea[i]         := cWorkArea
   ::aFields[i]           := cFields
   ::aInputMask[i]        := cInputMask
   ::aValueN[i]           := nValue
   ::aFontName[i]         := cFontName
   ::aFontSize[i]         := nFontSize
   ::aBold[i]             := lBold
   ::aFontItalic[i]       := lItalic
   ::aFontUnderline[i]    := lUnderline
   ::aFontStrikeout[i]    := lStrikeout
   ::aToolTip[i]          := cToolTip
   ::aBackColor[i]        := aBackColor
   ::aDynamicBackColor[i] := cDynBackColor
   ::aDynamicForeColor[i] := cDynForecolor
   ::aFontColor[i]        := aFontColor
   ::aOnGotFocus[i]       := cOnGotFocus
   ::aOnChange[i]         := cOnChange
   ::aOnLostFocus[i]      := cOnLostFocus
   ::aOnDblClick[i]       := cOnDblClick
   ::aAction[i]           := cAction
   ::aEdit[i]             := lEdit
   ::aInPlace[i]          := lInPlace
   ::aAppend[i]           := lAppend
   ::aOnHeadClick[i]      := cOnHeadClick
   ::aWhen[i]             := cWhen
   ::aValid[i]            := cValid
   ::aValidMess[i]        := cValidMess
   ::aReadOnlyB[i]        := cReadOnly
   ::aLock[i]             := lLock
   ::aDelete[i]           := lDelete
   ::aNoLines[i]          := lNoLines
   ::aImage[i]            := cImage
   ::aJustify[i]          := cJustify
   ::aNoVScroll[i]        := lNoVScroll
   ::aHelpID[i]           := nHelpId
   ::aBreak[i]            := lBreak
   ::aRTL[i]              := lRTL
   ::aOnAppend[i]         := cOnAppend
   ::aOnEditCell[i]       := cOnEditCell
   ::aColumnControls[i]   := cColControls
   ::aReplaceField[i]     := cReplaceField
   ::aSubClass[i]         := cSubClass
   ::aRecCount[i]         := lRecCount
   ::aColumnInfo[i]       := cColumnInfo
   ::aNoHeaders[i]        := lNoHeaders
   ::aOnEnter[i]          := cOnEnter
   ::aEnabled[i]          := lEnabled
   ::aNoTabStop[i]        := lNoTabStop
   ::aVisible[i]          := lVisible
   ::aDescend[i]          := lDescending
   ::aDeleteWhen[i]       := cDeleteWhen
   ::aDeleteMsg[i]        := cDeleteMsg
   ::aOnDelete[i]         := cOnDelete
   ::aHeaderImages[i]     := cHeaderImages
   ::aImagesAlign[i]      := cImagesAlign
   ::aFull[i]             := lFull
   ::aSelColor[i]         := aSelColor
   ::aEditKeys[i]         := cEditKeys
   ::aDoubleBuffer[i]     := lDoubleBuffer
   ::aSingleBuffer[i]     := lSingleBuffer
   ::aFocusRect[i]        := lFocusRect
   ::aNoFocusRect[i]      := lNoFocusRect
   ::aPLM[i]              := lPLM
   ::aFixedCols[i]        := lFixedCols
   ::aOnAbortEdit[i]      := cOnAbortEdit
   ::aFixedWidths[i]      := lFixedWidths
   ::aFixBlocks[i]        := lFixedBlocks
   ::aDynBlocks[i]        := lDynamicBlocks
   ::aBeforeColMove[i]    := cBeforeColMove
   ::aAfterColMove[i]     := cAfterColMove
   ::aBeforeColSize[i]    := cBeforeColSize
   ::aAfterColSize[i]     := cAfterColSize
   ::aBeforeAutoFit[i]    := cBeforeAutoFit
   ::aLikeExcel[i]        := lLikeExcel
   ::aButtons[i]          := lButtons
   ::aNoDelMsg[i]         := lNoDeleteMsg
   ::aFixedCtrls[i]       := lFixedCtrls
   ::aDynamicCtrls[i]     := lDynamicCtrls
   ::aShowNone[i]         := lNoShowEmpty
   ::aUpdateColors[i]     := lUpdateColors
   ::aOnHeadRClick[i]     := cOnHeadRClick
   ::aNoModalEdit[i]      := lNoModalEdit
   ::aByCell[i]           := lByCell
   ::aExtDblClick[i]      := lExtDblClick

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pGrid( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, aFontColor
LOCAL lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled
LOCAL cToolTip, cOnChange, cOnGotFocus, cOnLostFocus, cOnDblClick, cOnEnter
LOCAL cOnHeadClick, cOnEditCell, cOnCheckChg, nHelpId, cHeaders, cWidths, cItems
LOCAL nValue, cDynBackColor, cDynForecolor, cColControls, cReadOnly, cInputMask
LOCAL lMultiSelect, lNoLines, lInPlace, cImage, cJustify, lBreak, lEdit, cValid
LOCAL cWhen, cValidMess, lRTL, lNoTabStop, lFull, lCheckBoxes, aSelColor
LOCAL cAction, lButtons, lDelete, lAppend, cOnAppend, lVirtual, nItemCount
LOCAL cOnQueryData, lNoHeaders, cHeaderImages, cImagesAlign, lByCell, cEditKeys
LOCAL lDoubleBuffer, lSingleBuffer, lFocusRect, lNoFocusRect, lPLM, lFixedCols
LOCAL cOnAbortEdit, lFixedWidths, cBeforeColMove, cAfterColMove, cBeforeColSize
LOCAL cAfterColSize, cBeforeAutoFit, lLikeExcel, cDeleteWhen, cDeleteMsg
LOCAL cOnDelete, lNoDeleteMsg, lNoModalEdit, lFixedCtrls, lDynamicCtrls
LOCAL cOnHeadRClick, lNoClickOnChk, lNoRClickOnChk, lExtDblClick, cSubClass

   // Load properties
   cName          := ::aControlW[i]
   cObj           := ::LeaDato( cName, 'OBJ', '' )
   nRow           := Val( ::LeaRow( cName ) )
   nCol           := Val( ::LeaCol( cName ) )
   nWidth         := Val( ::LeaDato( cName, 'WIDTH', '240' ) )              // use control's default value
   nHeight        := Val( ::LeaDato( cName, 'HEIGHT', '120' ) )              // use control's default value
   cFontName      := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize      := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   aFontColor     := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor     := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lBold          := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold          := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic        := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic        := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline     := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline     := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout     := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout     := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor     := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor     := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible       := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible       := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled       := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled       := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip       := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnChange      := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnGotFocus    := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus   := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   cOnDblClick    := ::LeaDato( cName, 'ON DBLCLICK', '' )
   cOnEnter       := ::LeaDato( cName, 'ON ENTER', '' )
   cOnHeadClick   := ::LeaDato( cName, 'ON HEADCLICK', '' )
   cOnEditCell    := ::LeaDato( cName, 'ON EDITCELL', '' )
   cOnCheckChg    := ::LeaDato( cName, 'ON CHECKCHANGE', '' )
   nHelpId        := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   cHeaders       := ::LeaDato( cName, 'HEADERS', "{ 'one', 'two' }")
   cWidths        := ::LeaDato( cName, 'WIDTHS', "{ 80, 60 }")
   cItems         := ::LeaDato( cName, 'ITEMS', "")
   nValue         := Val( ::LeaDato( cName, 'VALUE', '') )
   cDynBackColor  := ::LeaDato( cName, "DYNAMICBACKCOLOR", '' )
   cDynForecolor  := ::LeaDato( cName, "DYNAMICFORECOLOR", '' )
   cColControls   := ::LeaDato( cName, "COLUMNCONTROLS", "" )
   cReadOnly      := ::LeaDato( cName, 'READONLY', "")
   cInputMask     := ::LeaDato( cName, 'INPUTMASK', "")
   lMultiSelect   := ( ::LeaDatoLogic( cName, 'MULTISELECT', "F" ) == "T" )
   lNoLines       := ( ::LeaDatoLogic( cName, 'NOLINES', "F" ) == "T" )
   lInPlace       := ( ::LeaDatoLogic( cName, 'INPLACE', "F" ) == "T" )
   cImage         := ::LeaDato( cName, 'IMAGE', "" )
   cJustify       := ::LeaDato( cName, 'JUSTIFY', "" )
   lBreak         := ( ::LeaDatoLogic( cName, "BREAK", "F" ) == "T" )
   lEdit          := ( ::LeaDatoLogic( cName, 'EDIT', "F" ) == "T" )
   cValid         := ::LeaDato( cName, 'VALID', "" )
   cWhen          := ::LeaDato( cName, 'WHEN', "" )
   cValidMess     := ::LeaDato( cName, 'VALIDMESSAGES', "" )
   lRTL           := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lNoTabStop     := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == "T" )
   lFull          := ( ::LeaDatoLogic( cName, 'FULLMOVE', "F" ) == "T" )
   lCheckBoxes    := ( ::LeaDatoLogic( cName, 'CHECKBOXES', "F" ) == "T" )
   aSelColor      := UpperNIL( ::LeaDato( cName, 'SELECTEDCOLORS', '' ) )
   cAction        := ::LeaDato( cName, 'ACTION', "" )
   cAction        := ::LeaDato( cName, 'ON CLICK',cAction )
   cAction        := ::LeaDato( cName, 'ONCLICK', cAction )
   lButtons       := ( ::LeaDatoLogic( cName, 'USEBUTTONS', "F" ) == "T" )
   lDelete        := ( ::LeaDatoLogic( cName, 'DELETE', "F" ) == "T" )
   lAppend        := ( ::LeaDatoLogic( cName, 'APPEND', "F" ) == "T" )
   cOnAppend      := ::LeaDato( cName, 'ON APPEND', '' )
   lVirtual       := ( ::LeaDatoLogic( cName, 'VIRTUAL', "F" ) == "T" )
   nItemCount     := Val( ::LeaDato( cName, 'ITEMCOUNT', '0' ) )
   cOnQueryData   := ::LeaDato( cName, 'ON QUERYDATA', '' )
   lNoHeaders     := ( ::LeaDatoLogic( cName, 'NOHEADERS', "F" ) == "T" )
   cHeaderImages  := ::LeaDato( cName, 'HEADERIMAGES', '' )
   cImagesAlign   := ::LeaDato( cName, 'IMAGESALIGN', '' )
   lByCell        := ( ::LeaDatoLogic( cName, 'NAVIGATEBYCELL', "F" ) == "T" )
   cEditKeys      := ::LeaDato( cName, 'EDITKEYS', '' )
   lDoubleBuffer  := ( ::LeaDatoLogic( cName, 'DOUBLEBUFFER', "F" ) == "T" )
   lSingleBuffer  := ( ::LeaDatoLogic( cName, 'SINGLEBUFFER', "F" ) == "T" )
   lFocusRect     := ( ::LeaDatoLogic( cName, 'FOCUSRECT', "F" ) == "T" )
   lNoFocusRect   := ( ::LeaDatoLogic( cName, 'NOFOCUSRECT', "F" ) == "T" )
   lPLM           := ( ::LeaDatoLogic( cName, 'PAINTLEFTMARGIN', "F" ) == "T" )
   lFixedCols     := ( ::LeaDatoLogic( cName, 'FIXEDCOLS', "F" ) == "T" )
   cOnAbortEdit   := ::LeaDato( cName, 'ON ABORTEDIT', '' )
   lFixedWidths   := ( ::LeaDatoLogic( cName, 'FIXEDWIDTHS', "F" ) == "T" )
   cBeforeColMove := ::LeaDato( cName, 'BEFORECOLMOVE', '' )
   cAfterColMove  := ::LeaDato( cName, 'AFTERCOLMOVE', '' )
   cBeforeColSize := ::LeaDato( cName, 'BEFORECOLSIZE', '' )
   cAfterColSize  := ::LeaDato( cName, 'AFTERCOLSIZE', '' )
   cBeforeAutoFit := ::LeaDato( cName, 'BEFOREAUTOFIT', '' )
   lLikeExcel     := ( ::LeaDatoLogic( cName, 'EDITLIKEEXCEL', "F" ) == "T" )
   cDeleteWhen    := ::LeaDato( cName, 'DELETEWHEN', '' )
   cDeleteMsg     := ::LeaDato( cName, 'DELETEMSG', '' )
   cOnDelete      := ::LeaDato( cName, 'ON DELETE', '' )
   lNoDeleteMsg   := ( ::LeaDatoLogic( cName, 'NODELETEMSG', "F" ) == "T" )
   lNoModalEdit   := ( ::LeaDatoLogic( cName, 'NOMODALEDIT', "F" ) == "T" )
   lFixedCtrls    := ( ::LeaDatoLogic( cName, 'FIXEDCONTROLS', "F" ) == "T" )
   lDynamicCtrls  := ( ::LeaDatoLogic( cName, 'DYNAMICCONTROLS', "F" ) == "T" )
   cOnHeadRClick  := ::LeaDato( cName, 'ON HEADRCLICK', '' )
   lNoClickOnChk  := ( ::LeaDatoLogic( cName, 'NOCLICKONCHECKBOX', "F" ) == "T" )
   lNoRClickOnChk := ( ::LeaDatoLogic( cName, 'NORCLICKONCHECKBOX', "F" ) == "T" )
   lExtDblClick   := ( ::LeaDatoLogic( cName, 'EXTDBLCLICK', "F" ) == "T" )
   cSubClass      := ::LeaDato( cName, 'SUBCLASS', '' )

   // Show control
   @ nRow, nCol GRID &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      HEADERS { cName, '' } ;
      WIDTHS { 100, 60 } ;
      ITEMS { { "", "" } } ;
      TOOLTIP 'To change properties and events right click on header area' ;
      ON GOTFOCUS ::Dibuja( This:Name ) ;
      ON CHANGE ::Dibuja( This:Name )
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]         := 'GRID'
   ::aName[i]             := cName
   ::aCObj[i]             := cObj
   ::aFontName[i]         := cFontName
   ::aFontSize[i]         := nFontSize
   ::aFontColor[i]        := aFontColor
   ::aBold[i]             := lBold
   ::aFontItalic[i]       := lItalic
   ::aFontUnderline[i]    := lUnderline
   ::aFontStrikeout[i]    := lStrikeout
   ::aBackColor[i]        := aBackColor
   ::aVisible[i]          := lVisible
   ::aEnabled[i]          := lEnabled
   ::aToolTip[i]          := cToolTip
   ::aOnChange[i]         := cOnChange
   ::aOnGotFocus[i]       := cOnGotFocus
   ::aOnLostFocus[i]      := cOnLostFocus
   ::aOnDblClick[i]       := cOnDblClick
   ::aOnEnter[i]          := cOnEnter
   ::aOnHeadClick[i]      := cOnHeadClick
   ::aOnEditCell[i]       := cOnEditCell
   ::aOnCheckChg[i]       := cOnCheckChg
   ::aHelpID[i]           := nHelpId
   ::aHeaders[i]          := cHeaders
   ::aWidths[i]           := cWidths
   ::aItems[i]            := cItems
   ::aValue[i]            := nValue
   ::aDynamicBackColor[i] := cDynBackColor
   ::aDynamicForeColor[i] := cDynForecolor
   ::aColumnControls[i]   := cColControls
   ::aReadOnlyB[i]        := cReadOnly
   ::aInputMask[i]        := cInputMask
   ::aMultiSelect[i]      := lMultiSelect
   ::aNoLines[i]          := lNoLines
   ::aInPlace[i]          := lInPlace
   ::aImage[i]            := cImage
   ::aJustify[i]          := cJustify
   ::aBreak[i]            := lBreak
   ::aEdit[i]             := lEdit
   ::aValid[i]            := cValid
   ::aWhen[i]             := cWhen
   ::aValidMess[i]        := cValidMess
   ::aRTL[i]              := lRTL
   ::aNoTabStop[i]        := lNoTabStop
   ::aFull[i]             := lFull
   ::aCheckBoxes[i]       := lCheckBoxes
   ::aSelColor[i]         := aSelColor
   ::aAction[i]           := cAction
   ::aButtons[i]          := lButtons
   ::aDelete[i]           := lDelete
   ::aAppend[i]           := lAppend
   ::aOnAppend[i]         := cOnAppend
   ::aVirtual[i]          := lVirtual
   ::aItemCount[i]        := nItemCount
   ::aOnQueryData[i]      := cOnQueryData
   ::aNoHeaders[i]        := lNoHeaders
   ::aHeaderImages[i]     := cHeaderImages
   ::aImagesAlign[i]      := cImagesAlign
   ::aByCell[i]           := lByCell
   ::aEditKeys[i]         := cEditKeys
   ::aDoubleBuffer[i]     := lDoubleBuffer
   ::aSingleBuffer[i]     := lSingleBuffer
   ::aFocusRect[i]        := lFocusRect
   ::aNoFocusRect[i]      := lNoFocusRect
   ::aPLM[i]              := lPLM
   ::aFixedCols[i]        := lFixedCols
   ::aOnAbortEdit[i]      := cOnAbortEdit
   ::aFixedWidths[i]      := lFixedWidths
   ::aBeforeColMove[i]    := cBeforeColMove
   ::aAfterColMove[i]     := cAfterColMove
   ::aBeforeColSize[i]    := cBeforeColSize
   ::aAfterColSize[i]     := cAfterColSize
   ::aBeforeAutoFit[i]    := cBeforeAutoFit
   ::aLikeExcel[i]        := lLikeExcel
   ::aDeleteWhen[i]       := cDeleteWhen
   ::aDeleteMsg[i]        := cDeleteMsg
   ::aOnDelete[i]         := cOnDelete
   ::aNoDelMsg[i]         := lNoDeleteMsg
   ::aNoModalEdit[i]      := lNoModalEdit
   ::aFixedCtrls[i]       := lFixedCtrls
   ::aDynamicCtrls[i]     := lDynamicCtrls
   ::aOnHeadRClick[i]     := cOnHeadRClick
   ::aNoClickOnCheck[i]   := lNoClickOnChk
   ::aNoRClickOnCheck[i]  := lNoRClickOnChk
   ::aExtDblClick[i]      := lExtDblClick
   ::aSubClass[i]         := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pDatePicker( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, nRow, nCol, nWidth, cFontName, nFontSize, cToolTip, cOnGotFocus
LOCAL cField, cValue, cOnLostFocus, cOnChange, cOnEnter, lShowNone, lUpDown
LOCAL lRightAlign, nHelpID, cObj, lBold, lItalic, lUnderline, lStrikeout, cRange
LOCAL lVisible, lEnabled, lRTL, lNoTabStop, lNoBorder, cSubClass, nHeight

   cName        := ::aControlW[i]
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '24' ) )
   cFontName    := ::Clean( ::LeaDato(cName,'FONT',''))
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnGotFocus  := ::LeaDato( cName, 'ON GOTFOCUS', '')
   cField       := ::Clean( ::LeaDato( cName, 'FIELD', '' ) )
   cValue       := ::LeaDato( cName, 'VALUE', '' )
   cOnLostFocus := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   cOnChange    := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnEnter     := ::LeaDato( cName, 'ON ENTER', '' )
   lShowNone    := ( ::LeaDatoLogic( cName, 'SHOWNONE', "F" ) == "T" )
   lUpDown      := ( ::LeaDatoLogic( cName, 'UPDOWN', "F" ) == "T" )
   lRightAlign  := ( ::LeaDatoLogic( cName, 'RIGHTALIGN', "F" ) == "T" )
   nHelpID      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lNoTabStop   := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == 'T' )
   cRange       := ::LeaDato( cName, 'RANGE', '' )
   lNoBorder    := ( ::LeaDatoLogic( cName, "NOBORDER", "F" ) == "T" )
   cSubClass    := ::LeaDato( cName, 'SUBCLASS', '' )

   ::aCtrlType[i]      := 'DATEPICKER'
   ::aName[i]          := cName
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aToolTip[i]       := cToolTip
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aField[i]         := cField
   ::avalue[i]         := cValue
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnChange[i]      := cOnChange
   ::aonenter[i]       := cOnEnter
   ::aShowNone[i]      := lShowNone
   ::aUpDown[i]        := lUpDown
   ::aRightAlign[i]    := lRightAlign
   ::aHelpID[i]        := nHelpID
   ::aCObj[i]          := cObj
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aRTL[i]           := lRTL
   ::aNoTabStop[i]     := lNoTabStop
   ::aRange[i]         := cRange
   ::aBorder[i]        := lNoBorder
   ::aSubClass[i]      := cSubClass

   @ nRow, nCol DATEPICKER &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      ON GOTFOCUS ::Dibuja(this:name) ;
      ON CHANGE ::Dibuja(this:name)
   ::oDesignForm:&cName:ToolTip := cToolTip
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTimePicker( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, nRow, nCol, nWidth, cFontName, nFontSize, cToolTip, cOnGotFocus
LOCAL cField, cValue, cOnLostFocus, cOnChange, cOnEnter, lShowNone, lUpDown
LOCAL lRightAlign, nHelpID, cObj, lBold, lItalic, lUnderline, lStrikeout
LOCAL lVisible, lEnabled, lRTL, lNoTabStop, lNoBorder, cSubClass, nHeight

   cName        := ::aControlW[i]
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '24' ) )
   cFontName    := ::Clean( ::LeaDato(cName,'FONT',''))
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnGotFocus  := ::LeaDato( cName, 'ON GOTFOCUS', '')
   cField       := ::Clean( ::LeaDato( cName, 'FIELD', '' ) )
   cValue       := ::LeaDato( cName, 'VALUE', '' )
   cOnLostFocus := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   cOnChange    := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnEnter     := ::LeaDato( cName, 'ON ENTER', '' )
   lShowNone    := ( ::LeaDatoLogic( cName, 'SHOWNONE', "F" ) == "T" )
   lUpDown      := ( ::LeaDatoLogic( cName, 'UPDOWN', "F" ) == "T" )
   lRightAlign  := ( ::LeaDatoLogic( cName, 'RIGHTALIGN', "F" ) == "T" )
   nHelpID      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lNoTabStop   := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == 'T' )
   lNoBorder    := ( ::LeaDatoLogic( cName, "NOBORDER", "F" ) == "T" )
   cSubClass    := ::LeaDato( cName, 'SUBCLASS', '' )

   ::aCtrlType[i]      := 'TIMEPICKER'
   ::aName[i]          := cName
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aToolTip[i]       := cToolTip
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aField[i]         := cField
   ::avalue[i]         := cValue
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnChange[i]      := cOnChange
   ::aonenter[i]       := cOnEnter
   ::aShowNone[i]      := lShowNone
   ::aUpDown[i]        := lUpDown
   ::aRightAlign[i]    := lRightAlign
   ::aHelpID[i]        := nHelpID
   ::aCObj[i]          := cObj
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aRTL[i]           := lRTL
   ::aNoTabStop[i]     := lNoTabStop
   ::aBorder[i]        := lNoBorder
   ::aSubClass[i]      := cSubClass

   @ nRow, nCol TIMEPICKER &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      ON GOTFOCUS ::Dibuja(this:name) ;
      ON CHANGE ::Dibuja(this:name)
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   ::oDesignForm:&cName:ToolTip := cToolTip

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pMonthcal( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, cValue, cFontName, nFontSize, aFontColor, lBold
LOCAL lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, cToolTip
LOCAL nHelpID, cOnChange, lNoToday, lNoTodayCircle, lWeekNumbers, lNoTabStop
LOCAL lRTL, cSubClass, aTitleFntClr, aTitleBckClr, aTrlngFntClr, aBckgrndClr

   // Load properties
   cName          := ::aControlW[i]
   cObj           := ::LeaDato( cName, 'OBJ', '' )
   nRow           := Val( ::LeaRow( cName ) )
   nCol           := Val( ::LeaCol( cName ) )
   cValue         :=  ::LeaDato( cName, 'VALUE', '' )
   cFontName      := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize      := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   aFontColor     := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor     := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lBold          := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold          := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic        := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic        := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline     := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline     := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout     := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout     := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor     := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor     := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible       := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible       := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled       := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled       := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip       := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   nHelpID        := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   cOnChange      := ::LeaDato( cName, 'ON CHANGE', '' )
   lNoToday       := ( ::LeaDatoLogic( cName, 'NOTODAY', 'F' ) == 'T' )
   lNoTodayCircle := ( ::LeaDatoLogic( cName, 'NOTODAYCIRCLE', 'F' ) == 'T' )
   lWeekNumbers   := ( ::LeaDatoLogic( cName, 'WEEKNUMBERS', 'F' ) == 'T' )
   lNoTabStop     := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == 'T' )
   lRTL           := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   cSubClass      := ::LeaDato( cName, 'SUBCLASS', '' )
   aTitleFntClr   := ::LeaDato( cName, 'TITLEFONTCOLOR', 'NIL' )
   aTitleBckClr   := ::LeaDato( cName, 'TITLEBACKCOLOR', 'NIL' )
   aTrlngFntClr   := ::LeaDato( cName, 'TRAILINGFONTCOLOR', 'NIL' )
   aBckgrndClr    := ::LeaDato( cName, 'BACKGROUNDCOLOR', 'NIL' )

   // Show control
   @ nRow, nCol MONTHCALENDAR &cName OF ( ::oDesignForm:Name ) ;
      VALUE cValue ;
      ON CHANGE ::Dibuja( This:Name )
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip
   IF aTitleFntClr # 'NIL'
      ::oDesignForm:&cName:TitleFontColor := &aTitleFntClr
   ENDIF
   IF aTitleBckClr # 'NIL'
      ::oDesignForm:&cName:TitleBackColor := &aTitleBckClr
   ENDIF
   IF aTrlngFntClr # 'NIL'
      ::oDesignForm:&cName:TrailingFontColor := &aTrlngFntClr
   ENDIF
   IF aBckgrndClr # 'NIL'
      ::oDesignForm:&cName:BackgroundColor := &aBckgrndClr
   ENDIF

   // Save properties
   ::aCtrlType[i]          := 'MONTHCALENDAR'
   ::aName[i]              := cName
   ::aCObj[i]              := cObj
   ::aValue[i]             := cValue
   ::aFontName[i]          := cFontName
   ::aFontSize[i]          := nFontSize
   ::aFontColor[i]         := aFontColor
   ::aBold[i]              := lBold
   ::aFontItalic[i]        := lItalic
   ::aFontUnderline[i]     := lUnderline
   ::aFontStrikeout[i]     := lStrikeout
   ::aBackColor[i]         := aBackColor
   ::aVisible[i]           := lVisible
   ::aEnabled[i]           := lEnabled
   ::aToolTip[i]           := cToolTip
   ::aHelpID[i]            := nHelpId
   ::aOnChange[i]          := cOnChange
   ::aNoToday[i]           := lNoToday
   ::aNoTodayCircle[i]     := lNoTodayCircle
   ::aWeekNumbers[i]       := lWeekNumbers
   ::aNoTabStop[i]         := lNoTabStop
   ::aRTL[i]               := lRTL
   ::aSubClass[i]          := cSubClass
   ::aTitleFontColor[i]    := aTitleFntClr
   ::aTitleBackColor[i]    := aTitleBckClr
   ::aTrailingFontColor[i] := aTrlngFntClr
   ::aBackgroundColor[i]   := aBckgrndClr

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pHyplink( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cValue, cAddress, cFontName
LOCAL nFontSize, aFontColor, lBold, lItalic, lUnderline, lStrikeout, aBackColor
LOCAL lVisible, lEnabled, cToolTip, nHelpID, lHandCursor, lAutoSize, lBorder
LOCAL lClientEdge, lHScroll, lVScroll, lTrans, lRTL

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '100' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '24' ) )
   cValue       := ::Clean( ::LeaDato( cName, 'VALUE', 'ooHG Home' ) )
   cAddress     := ::Clean( ::LeaDato( cName, 'ADDRESS', 'https://sourceforge.net/projects/oohg/' ) )
   cFontName    := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   aFontColor   := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   nHelpID      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lHandCursor  := ( ::LeaDatoLogic( cName, 'HANDCURSOR', 'F' ) == 'T' )
   lAutoSize    := ( ::LeaDatoLogic( cName, "AUTOSIZE", "F" ) == "T" )
   lBorder      := ( ::LeaDatoLogic( cName, "BORDER", "F" ) == "T" )
   lClientEdge  := ( ::LeaDatoLogic( cName, "CLIENTEDGE", "F") == "T" )
   lHScroll     := ( ::LeaDatoLogic( cName, "HSCROLL", "F" ) == "T" )
   lVScroll     := ( ::LeaDatoLogic( cName, "VSCROLL", "F" ) == "T" )
   lTrans       := ( ::LeaDatoLogic( cName, "TRANSPARENT", "F" ) == "T" )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )

   // Show control
   @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      BORDER ;
      VALUE cValue ;
      ACTION ::Dibuja( This:Name )
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip
   IF lHandCursor
      ::oDesignForm:&cName:Cursor := IDC_HAND
   ENDIF

   // Save properties
   ::aCtrlType[i]      := 'HYPERLINK'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aValue[i]         := cValue
   ::aAddress[i]       := cAddress
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aFontColor[i]     := aFontColor
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aHelpID[i]        := nHelpId
   ::aHandCursor[i]    := lHandCursor
   ::aAutoPlay[i]      := lAutoSize
   ::aBorder[i]        := lBorder
   ::aClientEdge[i]    := lClientEdge
   ::aNoHScroll[i]     := lHScroll
   ::aNoVScroll[i]     := lVScroll
   ::aTransparent[i]   := lTrans
   ::aRTL[i]           := lRTL

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pAnimatebox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nWidth, nHeight, cFile, lAutoplay, lCenter, lTrans, nHelpid
LOCAL cToolTip, lVisible, lEnabled, cSubClass, nRow, nCol, lRTL, lNoTabStop

   // Load properties
   cName      := ::aControlW[i]
   cObj       := ::LeaDato( cName, 'OBJ', '' )
   nRow       := Val( ::LeaRow( cName ) )
   nCol       := Val( ::LeaCol( cName ) )
   nWidth     := Val( ::LeaDato( cName, 'WIDTH', '0' ) )
   nHeight    := Val( ::LeaDato( cName, 'HEIGHT', '0' ) )
   cFile      := ::Clean( ::LeaDato( cName, 'FILE', '' ) )
   lAutoplay  := ( ::LeaDatoLogic( cName, 'AUTOPLAY', 'F') == "T" )
   lCenter    := ( ::LeaDatoLogic( cName, 'CENTER', 'F' ) == "T" )
   lTrans     := ( ::LeaDatoLogic( cName, 'TRANSPARENT', 'F' ) == "T" )
   nHelpid    := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   cToolTip   := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   lVisible   := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible   := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled   := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled   := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL       := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lNoTabStop := ( ::LeaDatoLogic( cName, 'NOTABSTOP', 'F' ) == 'T' )
   cSubClass  := ::LeaDato( cName, 'SUBCLASS', '' )

   // Show control
   IF lTrans
      @ nRow, nCol LABEL &cName ;
         OF ( ::oDesignForm:Name ) ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         VALUE cName ;
         BORDER ;
         TRANSPARENT ;
         ACTION ::Dibuja( This:Name )
   ELSE
      @ nRow, nCol LABEL &cName ;
         OF ( ::oDesignForm:Name ) ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         VALUE cName ;
         BORDER ;
         ACTION ::Dibuja( This:Name )
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]    := 'ANIMATE'
   ::aName[i]        := cName
   ::aCObj[i]        := cObj
   ::aFile[i]        := cFile
   ::aAutoPlay[i]    := lAutoplay
   ::aCenter[i]      := lCenter
   ::aTransparent[i] := lTrans
   ::aHelpID[i]      := nHelpId
   ::aToolTip[i]     := cToolTip
   ::aVisible[i]     := lVisible
   ::aEnabled[i]     := lEnabled
   ::aRTL[i]         := lRTL
   ::aNoTabStop[i]   := lNoTabStop
   ::aSubClass[i]    := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pImage( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cAction, cPicture, lStretch
LOCAL cToolTip, lBorder, lClientEdge, lVisible, lEnabled, lTrans, nHelpId
LOCAL aBackColor, lRTL, cBuffer, cHBitmap, lNoLoadTrans, lNoDIBSection
LOCAL lNo3DColors, lFit, lWhiteBack, lImageSize, cExclude, cSubClass

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::LeaDato( cName, 'OBJ', '' )
   nRow          := Val( ::LeaRow( cName ) )
   nCol          := Val( ::LeaCol( cName ) )
   nWidth        := Val( ::LeaDato( cName, 'WIDTH', '100' ) )
   nHeight       := Val( ::LeaDato( cName, 'HEIGHT', '100' ) )
   cAction       := ::LeaDato( cName, 'ACTION', "" )
   cAction       := ::LeaDato( cName, 'ON CLICK',cAction )
   cAction       := ::LeaDato( cName, 'ONCLICK', cAction )
   cPicture      := ::Clean( ::LeaDato(cName, 'PICTURE', '' ) )
   lStretch      := ( ::LeaDatoLogic( cName, 'STRETCH', "F") == "T" )
   cToolTip      := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   lBorder       := ( ::LeaDatoLogic( cName, "BORDER", "F" ) == "T" )
   lClientEdge   := ( ::LeaDatoLogic( cName, "CLIENTEDGE", "F") == "T" )
   lVisible      := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lTrans        := ( ::LeaDatoLogic( cName, "TRANSPARENT", "F" ) == "T" )
   nHelpId       := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   aBackColor    := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lRTL          := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   cBuffer       := ::LeaDato( cName, 'BUFFER', "" )
   cHBitmap      := ::LeaDato( cName, 'HBITMAP', "" )
   lNoLoadTrans  := ( ::LeaDatoLogic( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lNoDIBSection := ( ::LeaDatoLogic( cName, 'NODIBSECTION', "F" ) == "T" )
   lNo3DColors   := ( ::LeaDatoLogic( cName, 'NO3DCOLORS', "F" ) == "T" )
   lFit          := ( ::LeaDatoLogic( cName, 'NORESIZE', "F" ) == "T" )
   lWhiteBack    := ( ::LeaDatoLogic( cName, 'WHITEBACKGROUND', "F" ) == "T" )
   lImageSize    := ( ::LeaDatoLogic( cName, 'IMAGESIZE', "F" ) == "T" )
   cExclude      := ::LeaDato( cName, 'EXCLUDEAREA', "" )
   cSubClass     := ::LeaDato( cName, 'SUBCLASS', '' )

   // Show control
   IF lTrans
      @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         VALUE cName ;
         BORDER ;
         TRANSPARENT ;
         ACTION ::Dibuja( This:Name )
   ELSE
      @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         VALUE cName ;
         BORDER ;
         ACTION ::Dibuja( This:Name )
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF

   // Save properties
   ::aCtrlType[i]    := 'IMAGE'
   ::aName[i]        := cName
   ::aCObj[i]        := cObj
   ::aAction[i]      := cAction
   ::aPicture[i]     := cPicture
   ::aStretch[i]     := lStretch
   ::aToolTip[i]     := cToolTip
   ::aBorder[i]      := lBorder
   ::aClientEdge[i]  := lClientEdge
   ::aVisible[i]     := lVisible
   ::aEnabled[i]     := lEnabled
   ::aTransparent[i] := lTrans
   ::aHelpID[i]      := nHelpid
   ::aBackColor[i]   := aBackColor
   ::aRTL[i]         := lRTL
   ::aBuffer[i]      := cBuffer
   ::aHBitmap[i]     := cHBitmap
   ::aNoLoadTrans[i] := lNoLoadTrans
   ::aDIBSection[i]  := lNoDIBSection
   ::aNo3DColors[i]  := lNo3DColors
   ::aFit[i]         := lFit
   ::aWhiteBack[i]   := lWhiteBack
   ::aImageSize[i]   := lImageSize
   ::aExclude[i]     := cExclude
   ::aSubClass[i]    := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pPicButt( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, aBackColor, lVisible, lEnabled
LOCAL cToolTip, cOnGotFocus, cOnLostFocus, nHelpId, cPicture, cAction
LOCAL lNoTabStop, lFlat, cBuffer, cHBitmap, lNoLoadTrans, lForceScale
LOCAL lNo3DColors, lFit, lDIBSection, cOnMouseMove, lThemed, cImgMargin, lTop
LOCAL lBottom, lLeft, lRight, lCenter, lCancel, cSubClass, cAuxFile

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::LeaDato( cName, 'OBJ', '' )
   nRow          := Val( ::LeaRow( cName ) )
   nCol          := Val( ::LeaCol( cName ) )
   nWidth        := Val( ::LeaDato( cName, 'WIDTH', '100' ) )
   nHeight       := Val( ::LeaDato( cName, 'HEIGHT', '28' ) )
   aBackColor    := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible      := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip      := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnGotFocus   := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus  := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   nHelpId       := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   cPicture      := ::Clean( ::LeaDato( cName, 'PICTURE', '' ) )
   cAction       := ::LeaDato( cName, 'ACTION', "MsgInfo( 'Button pressed' )" )
   cAction       := ::LeaDato( cName, 'ON CLICK',cAction )
   cAction       := ::LeaDato( cName, 'ONCLICK', cAction )
   lNoTabStop    := ( ::LeaDatoLogic( cName, 'NOTABSTOP', "F" ) == "T" )
   lFlat         := ( ::LeaDatoLogic( cName, 'FLAT', "F" ) == "T" )
   cBuffer       := ::LeaDato( cName, 'BUFFER', "" )
   cHBitmap      := ::LeaDato( cName, 'HBITMAP', "" )
   lNoLoadTrans  := ( ::LeaDatoLogic( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lForceScale   := ( ::LeaDatoLogic( cName, 'FORCESCALE', "F" ) == "T" )
   lNo3DColors   := ( ::LeaDatoLogic( cName, 'NO3DCOLORS', "F" ) == "T" )
   lFit          := ::LeaDatoLogic( cName, 'AUTOFIT', "F" )
   lFit          := ( ::LeaDatoLogic( cName, 'ADJUST', lFit ) == "T" )
   lDIBSection   := ( ::LeaDatoLogic( cName, 'DIBSECTION', "F" ) == "T" )
   cOnMouseMove  := ::LeaDato( cName, 'ON MOUSEMOVE', '' )
   lThemed       := ( ::LeaDatoLogic( cName, 'THEMED', "F" ) == "T" )
   cImgMargin    := ::LeaDato( cName, 'IMAGEMARGIN', "" )
   lTop          := ( ::LeaDatoLogic( cName, 'TOP', "F" ) == "T" )
   lBottom       := ( ::LeaDatoLogic( cName, 'BOTTOM', "F" ) == "T" )
   lLeft         := ( ::LeaDatoLogic( cName, 'LEFT', "F" ) == "T" )
   lRight        := ( ::LeaDatoLogic( cName, 'RIGHT', "F" ) == "T" )
   lCenter       := ( ::LeaDatoLogic( cName, 'CENTER', "F" ) == "T" )
   lCancel       := ( ::LeaDatoLogic( cName, 'CANCEL', "F" ) == "T" )
   cSubClass     := ::LeaDato( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'PICBUTT'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aHelpID[i]        := nHelpId
   ::aPicture[i]       := cPicture
   ::aAction[i]        := cAction
   ::aNoTabStop[i]     := lNoTabStop
   ::aFlat[i]          := lFlat
   ::aBuffer[i]        := cBuffer
   ::aHBitmap[i]       := cHBitmap
   ::aNoLoadTrans[i]   := lNoLoadTrans
   ::aForceScale[i]    := lForceScale
   ::aNo3DColors[i]    := lNo3DColors
   ::aFit[i]           := lFit
   ::aDIBSection[i]    := lDIBSection
   ::aOnMouseMove[i]   := cOnMouseMove
   ::aThemed[i]        := lThemed
   ::aImageMargin[i]   := cImgMargin
   ::aJustify[i]       := IIF( lTop, "TOP", IIF( lBottom, "BOTTOM", IIF( lLeft, "LEFT", IIF( lRight, "RIGHT", IIF( lCenter, "CENTER", "" ) ) ) ) )
   ::aCancel[i]        := lCancel
   ::aSubClass[i]      := cSubClass

   // Create control
   cAuxFile := cPicture + '.BMP'
   IF File( cAuxFile )
      @ nRow, nCol BUTTON &cName OF ( ::oDesignForm:Name ) ;
         PICTURE cAuxFile ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ACTION ::Dibuja( This:Name )
   ELSE
      @ nRow, nCol BUTTON &cName OF ( ::oDesignForm:Name ) ;
         PICTURE 'A4' ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ACTION ::Dibuja( This:Name )
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pPicCheckButt( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cPicture, lValue, cToolTip
LOCAL lNoTabStop, cOnChange, cOnGotFocus, cOnLostFocus, nHelpId, lEnabled
LOCAL lVisible, cBuffer, cHBitmap, lNoLoadTrans, lForceScale, cField, cAuxFile
LOCAL lNo3DColors, lFit, lDIBSection, lThemed, aBackColor, cOnMouseMove
LOCAL cImgMargin, lFlat, lTop, lBottom, lLeft, lRight, lCenter, cSubClass

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::LeaDato( cName, 'OBJ', '' )
   nRow          := Val( ::LeaRow( cName ) )
   nCol          := Val( ::LeaCol( cName ) )
   nWidth        := Val( ::LeaDato( cName, 'WIDTH', '100' ) )
   nHeight       := Val( ::LeaDato( cName, 'HEIGHT', '28' ) )
   cPicture      := ::Clean( ::LeaDato( cName, 'PICTURE', '' ) )
   lValue        := ( ::LeaDatoLogic( cName, 'VALUE', 'F' ) == "T" )
   cToolTip      := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   lNoTabStop    := ( ::LeaDatoLogic( cName, 'NOTABSTOP', "F" ) == "T" )
   cOnChange     := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnGotFocus   := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus  := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   nHelpId       := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lEnabled      := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lVisible      := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   cBuffer       := ::LeaDato( cName, 'BUFFER', "" )
   cHBitmap      := ::LeaDato( cName, 'HBITMAP', "" )
   lNoLoadTrans  := ( ::LeaDatoLogic( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lForceScale   := ( ::LeaDatoLogic( cName, 'FORCESCALE', "F" ) == "T" )
   cField        := ::LeaDato( cName, 'FIELD', '' )
   lNo3DColors   := ( ::LeaDatoLogic( cName, 'NO3DCOLORS', "F" ) == "T" )
   lFit          := ::LeaDatoLogic( cName, 'AUTOFIT', "F" )
   lFit          := ( ::LeaDatoLogic( cName, 'ADJUST', lFit ) == "T" )
   lDIBSection   := ( ::LeaDatoLogic( cName, 'DIBSECTION', "F" ) == "T" )
   lThemed       := ( ::LeaDatoLogic( cName, 'THEMED', "F" ) == "T" )
   aBackColor    := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   cOnMouseMove  := ::LeaDato( cName, 'ON MOUSEMOVE', '' )
   cImgMargin    := ::LeaDato( cName, 'IMAGEMARGIN', "" )
   lFlat         := ( ::LeaDatoLogic( cName, 'FLAT', "F" ) == "T" )
   lTop          := ( ::LeaDatoLogic( cName, 'TOP', "F" ) == "T" )
   lBottom       := ( ::LeaDatoLogic( cName, 'BOTTOM', "F" ) == "T" )
   lLeft         := ( ::LeaDatoLogic( cName, 'LEFT', "F" ) == "T" )
   lRight        := ( ::LeaDatoLogic( cName, 'RIGHT', "F" ) == "T" )
   lCenter       := ( ::LeaDatoLogic( cName, 'CENTER', "F" ) == "T" )
   cSubClass     := ::LeaDato( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'PICCHECKBUTT'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aPicture[i]       := cPicture
   ::aValueL[i]        := lValue
   ::aToolTip[i]       := cToolTip
   ::aNoTabStop[i]     := lNoTabStop
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aHelpID[i]        := nHelpId
   ::aEnabled[i]       := lEnabled
   ::aVisible[i]       := lVisible
   ::aBuffer[i]        := cBuffer
   ::aHBitmap[i]       := cHBitmap
   ::aNoLoadTrans[i]   := lNoLoadTrans
   ::aForceScale[i]    := lForceScale
   ::aField[i]         := cField
   ::aNo3DColors[i]    := lNo3DColors
   ::aFit[i]           := lFit
   ::aDIBSection[i]    := lDIBSection
   ::aThemed[i]        := lThemed
   ::aBackColor[i]     := aBackColor
   ::aOnMouseMove[i]   := cOnMouseMove
   ::aImageMargin[i]   := cImgMargin
   ::aFlat[i]          := lFlat
   ::aJustify[i]       := IIF( lTop, "TOP", IIF( lBottom, "BOTTOM", IIF( lLeft, "LEFT", IIF( lRight, "RIGHT", IIF( lCenter, "CENTER", "" ) ) ) ) )
   ::aSubClass[i]      := cSubClass

   // Create control
   cAuxFile := cPicture + '.BMP'          
   IF File( cAuxFile )
      @ nRow, nCol CHECKBUTTON &cName OF ( ::oDesignForm:Name ) ;
         PICTURE cAuxFile ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )
   ELSE
      @ nRow, nCol CHECKBUTTON &cName OF ( ::oDesignForm:Name ) ;
         PICTURE 'A4' ;
         WIDTH nWidth ;
         HEIGHT nHeight ;
         ON GOTFOCUS ::Dibuja( This:Name ) ;
         ON CHANGE ::Dibuja( This:Name )
   ENDIF
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip
   ::oDesignForm:&cName:Value := lValue

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pCheckBtn( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cCaption, cFontName, nFontSize
LOCAL lBold, lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled
LOCAL cToolTip, cOnGotFocus, cOnLostFocus, nHelpId, lRTL, cPicture, cBuffer
LOCAL cHBitmap, lNoLoadTrans, lForceScale, cField, lNo3DColors, lFit
local lDIBSection, lNoTabStop, cOnChange, lValue

   cName        := ::aControlW[i]

   // Load properties
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '100' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '28' ) )
   cCaption     := ::Clean( ::LeaDato( cName, 'CAPTION', cName ) )
   cFontName    := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnGotFocus  := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   nHelpId      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   cPicture     := ::Clean( ::LeaDato( cName, 'PICTURE', '' ) )
   cBuffer      := ::LeaDato( cName, 'BUFFER', "" )
   cHBitmap     := ::LeaDato( cName, 'HBITMAP', "" )
   lNoLoadTrans := ( ::LeaDatoLogic( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lForceScale  := ( ::LeaDatoLogic( cName, 'FORCESCALE', "F" ) == "T" )
   cField       := ::LeaDato( cName, 'FIELD', '' )
   lNo3DColors  := ( ::LeaDatoLogic( cName, 'NO3DCOLORS', "F" ) == "T" )
   lFit         := ::LeaDatoLogic( cName, 'AUTOFIT', "F" )
   lFit         := ( ::LeaDatoLogic( cName, 'ADJUST', lFit ) == "T" )
   lDIBSection  := ( ::LeaDatoLogic( cName, 'DIBSECTION', "F" ) == "T" )
   lNoTabStop   := ( ::LeaDatoLogic( cName, 'NOTABSTOP', "F" ) == "T" )
   cOnChange    := ::LeaDato( cName, 'ON CHANGE', '' )
   lValue       := ( ::LeaDato( cName, 'VALUE', ".F." ) == ".T." )

   // Save properties
   ::aCtrlType[i]      := 'CHECKBTN'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aCaption[i]       := cCaption
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aHelpID[i]        := nHelpId
   ::aRTL[i]           := lRTL
   ::aPicture[i]       := cPicture
   ::aBuffer[i]        := cBuffer
   ::aHBitmap[i]       := cHBitmap
   ::aNoLoadTrans[i]   := lNoLoadTrans
   ::aForceScale[i]    := lForceScale
   ::aField[i]         := cField
   ::aNo3DColors[i]    := lNo3DColors
   ::aFit[i]           := lFit
   ::aDIBSection[i]    := lDIBSection
   ::aNoTabStop[i]     := lNoTabStop
   ::aOnChange[i]      := cOnChange
   ::aValueL[i]        := lValue

   // Create control
   @ nRow, nCol CHECKBUTTON &cName OF ( ::oDesignForm:Name ) ;
      CAPTION Ccaption ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      VALUE lValue ;
      ON GOTFOCUS ::Dibuja( This:Name ) ;
      ON CHANGE ::Dibuja( This:Name )
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pComboBox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, cFontName, nFontSize, aFontColor, lBold
LOCAL lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, cToolTip
LOCAL cOnChange, cOnGotFocus, cOnLostFocus, cOnEnter, cOnDisplayChange, cItems
LOCAL cItemSource, nValue, cValueSource, nHelpId, lNoTabStop, lSort, lBreak
LOCAL lDisplayEdit, lRTL, cImage, lFit, nTextHeight, cItemImageNumber
LOCAL cImageSource, lFirstItem, nListWidth, cOnListDisplay, cOnListClose
LOCAL lDelayedLoad, lIncremental, lIntegralHeight, lRefresh, lNoRefresh
LOCAL cSourceOrder, cOnRefresh, nSearchLapse, cGripperText, cSubClass

   // Load properties
   cName             := ::aControlW[i]
   cObj              := ::LeaDato( cName, 'OBJ', '' )
   nRow              := Val( ::LeaRow( cName ) )
   nCol              := Val( ::LeaCol( cName ) )
   nWidth            := Val( ::LeaDato( cName, 'WIDTH', '120' ) )              // use control's default value
   cFontName         := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize         := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   aFontColor        := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor        := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lBold             := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold             := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic           := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic           := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline        := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline        := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout        := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout        := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor        := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor        := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible          := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible          := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled          := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled          := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip          := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnChange         := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnGotFocus       := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus      := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   cOnEnter          := ::LeaDato( cName, 'ON ENTER', '' )
   cOnDisplayChange  := ::LeaDato( cName, 'ON DISPLAYCHANGE', '' )
   cItems            := ::LeaDato( cName, 'ITEMS', '' )
   cItemSource       := ::LeaDato( cName, 'ITEMSOURCE', '' )
   nValue            := Val( ::LeaDato( cName, 'VALUE', '0' ) )
   cValueSource      := ::LeaDato( cName, 'VALUESOURCE', '' )
   nHelpId           := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lNoTabStop        := ( ::LeaDatoLogic( cName, 'NOTABSTOP', "F" ) == "T" )
   lSort             := ( ::LeaDatoLogic( cName, 'SORT', "F" ) == "T" )
   lBreak            := ( ::LeaDatoLogic( cName, 'BREAK', "F" ) == "T" )
   lDisplayEdit      := ( ::LeaDatoLogic( cName, 'DISPLAYEDIT', "F" ) == "T" )
   lRTL              := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   cImage            := ::Clean( ::LeaDato( cName, 'IMAGE', '' ) )
   lFit              := ( ::LeaDatoLogic( cName, 'FIT', "F" ) == "T" )
   nTextHeight       := Val( ::LeaDato( cName, 'TEXTHEIGHT', '0' ) )
   cItemImageNumber  := ::LeaDato( cName, 'ITEMIMAGENUMBER', '' )
   cImageSource      := ::LeaDato( cName, 'IMAGESOURCE', '' )
   lFirstItem        := ( ::LeaDatoLogic( cName, 'FIRSTITEM', "F" ) == "T" )
   nListWidth        := Val( ::LeaDato( cName, 'LISTWIDTH', '0' ) )
   cOnListDisplay    := ::LeaDato( cName, 'ON LISTDISPLAY', '' )
   cOnListClose      := ::LeaDato( cName, 'ON LISTCLOSE', '' )
   lDelayedLoad      := ( ::LeaDatoLogic( cName, 'DELAYEDLOAD', "F" ) == "T" )
   lIncremental      := ( ::LeaDatoLogic( cName, 'INCREMENTAL', "F" ) == "T" )
   lIntegralHeight   := ( ::LeaDatoLogic( cName, 'INTEGRALHEIGHT', "F" ) == "T" )
   lRefresh          := ( ::LeaDatoLogic( cName, 'REFRESH', "F" ) == "T" )
   lNoRefresh        := ( ::LeaDatoLogic( cName, 'NOREFRESH', "F" ) == "T" )
   cSourceOrder      := ::LeaDato( cName, 'SOURCEORDER', '' )
   cOnRefresh        := ::LeaDato( cName, 'ON REFRESH', '' )
   nSearchLapse      := Val( ::LeaDato( cName, 'SEARCHLAPSE', '0' ) )
   cGripperText      := ::LeaDato( cName, 'GRIPPERTEXT', '' )
   cSubClass         := ::LeaDato( cName, 'SUBCLASS', '' )

   // Show control
   @ nRow, nCol COMBOBOX &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nwidth ;
      ITEMS { cName, ' ' } ;
      VALUE 1 ;
      ON GOTFOCUS ::Dibuja( This:Name ) ;
      ON CHANGE ::Dibuja( This:Name )
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]        := 'COMBO'
   ::aName[i]            := cName
   ::aCObj[i]            := cObj
   ::aFontName[i]        := cFontName
   ::aFontSize[i]        := nFontSize
   ::aFontColor[i]       := aFontColor
   ::aBold[i]            := lBold
   ::aFontItalic[i]      := lItalic
   ::aFontUnderline[i]   := lUnderline
   ::aFontStrikeout[i]   := lStrikeout
   ::aBackColor[i]       := aBackColor
   ::aVisible[i]         := lVisible
   ::aEnabled[i]         := lEnabled
   ::aToolTip[i]         := cToolTip
   ::aOnChange[i]        := cOnChange
   ::aOnGotFocus[i]      := cOnGotFocus
   ::aOnLostFocus[i]     := cOnLostFocus
   ::aOnEnter[i]         := cOnEnter
   ::aOnDisplayChange[i] := cOnDisplayChange
   ::aItems[i]           := cItems
   ::aItemSource[i]      := cItemSource
   ::aValueN[i]          := nValue
   ::aValueSource[i]     := cValueSource
   ::aHelpID[i]          := nHelpId
   ::aNoTabStop[i]       := lNoTabStop
   ::aSort[i]            := lSort
   ::aBreak[i]           := lBreak
   ::aDisplayEdit[i]     := lDisplayEdit
   ::aRTL[i]             := lRTL
   ::aImage[i]           := cImage
   ::aFit[i]             := lFit
   ::aTextHeight[i]      := nTextHeight
   ::aItemImageNumber[i] := cItemImageNumber
   ::aImageSource[i]     := cImageSource
   ::aFirstItem[i]       := lFirstItem
   ::aListWidth[i]       := nListWidth
   ::aOnListDisplay[i]   := cOnListDisplay
   ::aOnListClose[i]     := cOnListClose
   ::aDelayedLoad[i]     := lDelayedLoad
   ::aIncremental[i]     := lIncremental
   ::aIntegralHeight[i]  := lIntegralHeight
   ::aRefresh[i]         := lRefresh
   ::aNoRefresh[i]       := lNoRefresh
   ::aSourceOrder[i]     := cSourceOrder
   ::aOnRefresh[i]       := cOnRefresh
   ::aSearchLapse[i]     := nSearchLapse
   ::aGripperText[i]     := cGripperText
   ::aSubClass[i]        := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pListBox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cToolTip, nHelpId, cFontName
LOCAL nFontSize, lBold, lItalic, lUnderline, lStrikeout, aBackColor, aFontColor
LOCAL lVisible, lEnabled, lRTL, cOnEnter, lNoVScroll, cImage, lFit, nTextHeight
LOCAL cOnGotFocus, cOnLostFocus, cOnChange, cOnDblClick, cItems, nValue
LOCAL lMultiSelect, lNoTabStop, lBreak, lSort, cSubClass

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '100' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '100' ) )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   nHelpId      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   cFontName    := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor   := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   cOnEnter     := ::LeaDato( cName, 'ON ENTER', '' )
   lNoVScroll   := ( ::LeaDatoLogic( cName, "NOVSCROLL", "F" ) == "T" )
   cImage       := ::Clean( ::LeaDato( cName, 'IMAGE', '' ) )
   lFit         := ( ::LeaDatoLogic( cName, 'FIT', "F" ) == "T" )
   nTextHeight  := Val( ::LeaDato( cName, 'TEXTHEIGHT', '0' ) )
   cOnGotFocus  := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   cOnChange    := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnDblClick  := ::LeaDato( cName, 'ON DBLCLICK', '' )
   cItems       := ::LeaDato( cName, 'ITEMS', '' )
   nValue       := Val( ::LeaDato( cName, 'VALUE', '0' ) )
   lMultiSelect := ( ::LeaDatoLogic( cName, 'MULTISELECT', "F" ) == "T" )
   lNoTabStop   := ( ::LeaDatoLogic( cName, 'NOTABSTOP', "F" ) == "T" )
   lBreak       := ( ::LeaDatoLogic( cName, 'BREAK', "F" ) == "T" )
   lSort        := ( ::LeaDatoLogic( cName, 'SORT', "F" ) == "T" )
   cSubClass    := ::LeaDato( cName, 'SUBCLASS', '' )

   // Show control
   @ nRow, nCol LISTBOX &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nwidth ;
      HEIGHT nheight ;
      ITEMS { cName } ;
      ON GOTFOCUS ::Dibuja( This:Name ) ;
      ON CHANGE ::Dibuja( This:Name )
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   // Save properties
   ::aCtrlType[i]      := 'LIST'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aToolTip[i]       := cToolTip
   ::aHelpID[i]        := nHelpid
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aFontColor[i]     := aFontColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aRTL[i]           := lRTL
   ::aOnEnter[i]       := cOnEnter
   ::aNoVScroll[i]     := lNoVScroll
   ::aImage[i]         := cImage
   ::aFit[i]           := lFit
   ::aTextHeight[i]    := nTextHeight
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aOnChange[i]      := cOnChange
   ::aOnDblClick[i]    := cOnDblClick
   ::aItems[i]         := cItems
   ::aValuen[i]        := nValue
   ::aMultiSelect[i]   := lMultiSelect
   ::aNotabstop[i]     := lNoTabStop
   ::aBreak[i]         := lBreak
   ::aSort[i]          := lSort
   ::aSubClass[i]      := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pCheckBox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, cToolTip
LOCAL cCaption, cOnChange, cField, cOnGotFocus, cOnLostFocus, nHelpID, lTrans
LOCAL lNoTabStop, cValue, lBold, lItalic, lUnderline, lStrikeout, aBackColor
LOCAL aFontColor, lVisible, lEnabled, lRTL, lThemed, lAutoSize, lLeft, l3State
LOCAL cSubClass

   cName        := ::aControlW[i]
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '100' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '28' ) )
   cFontName    := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cCaption     := ::Clean( ::LeaDato( cName, 'CAPTION', cName ) )
   cOnChange    := ::LeaDato( cName, 'ON CHANGE', '' )
   cField       := ::LeaDato( cName, 'FIELD', '' )
   cOnGotFocus  := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   nHelpID      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lTrans       := ( ::LeaDatoLogic( cName, "TRANSPARENT", "F" ) == "T" )
   lNoTabStop   := ( ::LeaDatoLogic( cName, 'NOTABSTOP', "F" ) == "T" )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   aFontColor   := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lThemed      := ( ::LeaDatoLogic( cName, 'THEMED', "F" ) == "T" )
   lAutoSize    := ( ::LeaDatoLogic( cName, "AUTOSIZE", "F" ) == "T" )
   lLeft        := ( ::LeaDatoLogic( cName, 'LEFTALIGN', "F" ) == "T" )
   l3State      := ( ::LeaDatoLogic( cName, 'THREESTATE', "F" ) == "T" )
   cValue       := ::LeaDato( cName, 'VALUE', "" )
   cSubClass    := ::LeaDato( cName, 'SUBCLASS', '' )

   IF l3State
      IF cValue == ".T."
         // OK
      ELSEIF cValue == ".F."
         // OK
      ELSE
         cValue := 'NIL'
      ENDIF
   ELSE
      IF cValue == ".T."
         // OK
      ELSE
         cValue := ".F."
      ENDIF
   ENDIF

// TODO: Use OOP syntax

   // Show control
   IF lRTL
      IF lLeft
         IF l3State
            IF lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  RTL ;
                  LEFTALIGN ;
                  THREESTATE ;
                  TRANSPARENT ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ELSE  // ! lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  RTL ;
                  LEFTALIGN ;
                  THREESTATE ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ENDIF
         ELSE   // ! l3State
            IF lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  RTL ;
                  LEFTALIGN ;
                  TRANSPARENT ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ELSE   // ! lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  RTL ;
                  LEFTALIGN ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ENDIF
         ENDIF
      ELSE   // ! lLeft
         IF l3State
            IF lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  RTL ;
                  THREESTATE ;
                  TRANSPARENT ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ELSE
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  RTL ;
                  THREESTATE ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ENDIF
         ELSE   // ! l3State
            IF lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  RTL ;
                  TRANSPARENT ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ELSE   // ! lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  RTL ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ENDIF
         ENDIF
      ENDIF
   ELSE   // ! lRTL
      IF lLeft
         IF l3State
            IF lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  LEFTALIGN ;
                  THREESTATE ;
                  TRANSPARENT ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ELSE  // ! lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  LEFTALIGN ;
                  THREESTATE ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ENDIF
         ELSE   // ! l3State
            IF lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  LEFTALIGN ;
                  TRANSPARENT ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ELSE   // ! lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  LEFTALIGN ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ENDIF
         ENDIF
      ELSE   // ! lLeft
         IF l3State
            IF lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  THREESTATE ;
                  TRANSPARENT ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ELSE
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  THREESTATE ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ENDIF
         ELSE   // ! l3State
            IF lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  TRANSPARENT ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ELSE   // ! lTrans
               @ nRow, nCol CHECKBOX &cName OF ( ::oDesignForm:Name ) ;
                  CAPTION cCaption ;
                  WIDTH nwidth ;
                  HEIGHT nheight ;
                  VALUE &cValue ;
                  ON GOTFOCUS ::Dibuja( This:Name ) ;
                  ON CHANGE ::Dibuja( This:Name )
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip
   IF lAutoSize
      ::oDesignForm:&cName:Autosize := .T.
   ENDIF
   IF lThemed
      ::oDesignForm:&cName:lThemed := .T.
      ::oDesignForm:&cName:Redraw()
   ENDIF

   // Save properties
   ::aCtrlType[i]      := 'CHECKBOX'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aToolTip[i]       := cToolTip
   ::aCaption[i]       := cCaption
   ::aOnChange[i]      := cOnChange
   ::aField[i]         := cField
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aHelpID[i]        := nHelpID
   ::aTransparent[i]   := lTrans
   ::aNoTabStop[i]     := lNoTabStop
   ::aValue[i]         := cValue
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aFontColor[i]     := aFontColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aRTL[i]           := lRTL
   ::aThemed[i]        := lThemed
   ::aAutoPlay[i]      := lAutoSize
   ::aLeft[i]          := lLeft
   ::a3State[i]        := l3State
   ::aSubClass[i]      := cSubClass

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pButton( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, lBold
LOCAL lItalic, lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, cToolTip
LOCAL cOnGotFocus, cOnLostFocus, nHelpId, cCaption, cPicture, cAction, lNoTabStop
LOCAL lFlat, lTop, lBottom, lLeft, lRight, lCenter, cOnMouseMove, lRTL, lNoPrefix
LOCAL lNoLoadTrans, lForceScale, lCancel, lMultiLine, lThemed, lNo3DColors, lFit
LOCAL lDIBSection, cBuffer, cHBitmap, cImgMargin, cSubClass

   // Load properties
   cName         := ::aControlW[i]
   cObj          := ::LeaDato( cName, 'OBJ', '' )
   nRow          := Val( ::LeaRow( cName ) )
   nCol          := Val( ::LeaCol( cName ) )
   nWidth        := Val( ::LeaDato( cName, 'WIDTH', '100' ) )
   nHeight       := Val( ::LeaDato( cName, 'HEIGHT', '28' ) )
   cFontName     := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize     := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   lBold         := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold         := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic       := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic       := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline    := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline    := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout    := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout    := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor    := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor    := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible      := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible      := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled      := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled      := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   cToolTip      := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   cOnGotFocus   := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus  := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   nHelpId       := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   cCaption      := ::Clean( ::LeaDato( cName, 'CAPTION', cName ) )
   cPicture      := ::Clean( ::LeaDato( cName, 'PICTURE', '' ) )
   cAction       := ::LeaDato( cName, 'ACTION', "MsgInfo( 'Button pressed' )" )
   cAction       := ::LeaDato( cName, 'ON CLICK',cAction )
   cAction       := ::LeaDato( cName, 'ONCLICK', cAction )
   lNoTabStop    := ( ::LeaDatoLogic( cName, 'NOTABSTOP', "F" ) == "T" )
   lFlat         := ( ::LeaDatoLogic( cName, 'FLAT', "F" ) == "T" )
   lTop          := ( ::LeaDatoLogic( cName, 'TOP', "F" ) == "T" )
   lBottom       := ( ::LeaDatoLogic( cName, 'BOTTOM', "F" ) == "T" )
   lLeft         := ( ::LeaDatoLogic( cName, 'LEFT', "F" ) == "T" )
   lRight        := ( ::LeaDatoLogic( cName, 'RIGHT', "F" ) == "T" )
   lCenter       := ( ::LeaDatoLogic( cName, 'CENTER', "F" ) == "T" )
   cOnMouseMove  := ::LeaDato( cName, 'ON MOUSEMOVE', '' )
   lRTL          := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lNoPrefix     := ( ::LeaDatoLogic( cName, 'NOPREFIX', "F" ) == "T" )
   lNoLoadTrans  := ( ::LeaDatoLogic( cName, 'NOLOADTRANSPARENT', "F" ) == "T" )
   lForceScale   := ( ::LeaDatoLogic( cName, 'FORCESCALE', "F" ) == "T" )
   lCancel       := ( ::LeaDatoLogic( cName, 'CANCEL', "F" ) == "T" )
   lMultiLine    := ( ::LeaDatoLogic( cName, 'MULTILINE', "F" ) == "T" )
   lThemed       := ( ::LeaDatoLogic( cName, 'THEMED', "F" ) == "T" )
   lNo3DColors   := ( ::LeaDatoLogic( cName, 'NO3DCOLORS', "F" ) == "T" )
   lFit          := ::LeaDatoLogic( cName, 'AUTOFIT', "F" )
   lFit          := ( ::LeaDatoLogic( cName, 'ADJUST', lFit ) == "T" )
   lDIBSection   := ( ::LeaDatoLogic( cName, 'DIBSECTION', "F" ) == "T" )
   cBuffer       := ::LeaDato( cName, 'BUFFER', "" )
   cHBitmap      := ::LeaDato( cName, 'HBITMAP', "" )
   cImgMargin    := ::LeaDato( cName, 'IMAGEMARGIN', "" )
   cSubClass     := ::LeaDato( cName, 'SUBCLASS', '' )

   // Save properties
   ::aCtrlType[i]      := 'BUTTON'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aToolTip[i]       := cToolTip
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aHelpID[i]        := nHelpId
   ::aCaption[i]       := cCaption
   ::aPicture[i]       := cPicture
   ::aAction[i]        := cAction
   ::aNoTabStop[i]     := lNoTabStop
   ::aFlat[i]          := lFlat
   ::aJustify[i]       := IIF( lTop, "TOP", IIF( lBottom, "BOTTOM", IIF( lLeft, "LEFT", IIF( lRight, "RIGHT", IIF( lCenter, "CENTER", "" ) ) ) ) )
   ::aOnMouseMove[i]   := cOnMouseMove
   ::aRTL[i]           := lRTL
   ::aNoPrefix[i]      := lNoPrefix
   ::aNoLoadTrans[i]   := lNoLoadTrans
   ::aForceScale[i]    := lForceScale
   ::aCancel[i]        := lCancel
   ::aMultiLine[i]     := lMultiLine
   ::aThemed[i]        := lThemed
   ::aNo3DColors[i]    := lNo3DColors
   ::aFit[i]           := lFit
   ::aDIBSection[i]    := lDIBSection
   ::aBuffer[i]        := cBuffer
   ::aHBitmap[i]       := cHBitmap
   ::aImageMargin[i]   := cImgMargin
   ::aSubClass[i]      := cSubClass

   // Create control
   ::CreateControl( aScan( ::ControlType, ::aCtrlType[i] ), i )
   ::oDesignForm:&cName:Row    := nRow
   ::oDesignForm:&cName:Col    := nCol
   ::oDesignForm:&cName:Width  := nWidth
   ::oDesignForm:&cName:Height := nHeight

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

//------------------------------------------------------------------------------
METHOD pTextBox( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, cObj, nRow, nCol, nWidth, nHeight, cFontName, nFontSize, cValue
LOCAL cField, cToolTip, nMaxLength, nHelpID, lUpperCase, lLowerCase, lPassword
LOCAL lNumeric, lRightAlign, lNoTabStop, lDate, cInputMask, cFormat, cOnEnter
LOCAL cOnChange, cOnGotFocus, cOnLostFocus, lReadonly, nFocusedPos, cValid
LOCAL cAction, cAction2, cImage, cWhen, lNoBorder, cSubClass, lBold, lItalic
LOCAL lUnderline, lStrikeout, aBackColor, lVisible, lEnabled, aFontColor
LOCAL lCenterAlign, lRTL, lAutoSkip, cOnTextFill, nDefaultYear, nButtonWidth
LOCAL nInsertType

   // Load properties
   cName        := ::aControlW[i]
   cObj         := ::LeaDato( cName, 'OBJ', '' )
   nRow         := Val( ::LeaRow( cName ) )
   nCol         := Val( ::LeaCol( cName ) )
   nWidth       := Val( ::LeaDato( cName, 'WIDTH', '120' ) )
   nHeight      := Val( ::LeaDato( cName, 'HEIGHT', '24' ) )
   cFontName    := ::Clean( ::LeaDato( cName, 'FONT', '' ) )
   nFontSize    := Val( ::LeaDato( cName, 'SIZE', '0' ) )
   cValue       := ::Clean( ::LeaDato( cName, 'VALUE', '' ) )
   cField       := ::LeaDato( cName, 'FIELD', '' )
   cToolTip     := ::Clean( ::LeaDato( cName, 'TOOLTIP', '' ) )
   nMaxLength   := Val( ::LeaDato( cName, 'MAXLENGTH', '0' ) )
   nHelpID      := Val( ::LeaDato( cName, 'HELPID', '0' ) )
   lUpperCase   := ( ::LeaDatoLogic( cName, "UPPERCASE", "F" ) == "T" )
   lLowerCase   := ( ::LeaDatoLogic( cName, "LOWERCASE", "F" ) == "T" )
   lPassword    := ( ::LeaDatoLogic( cName, "PASSWORD", "F" ) == "T" )
   lNumeric     := ( ::LeaDatoLogic( cName, "NUMERIC", "F" ) == "T" )
   lRightAlign  := ( ::LeaDatoLogic( cName, "RIGHTALIGN", "F" ) == "T" )
   lNoTabStop   := ( ::LeaDatoLogic( cName, 'NOTABSTOP', "F" ) == "T" )
   lDate        := ( ::LeaDatoLogic( cName, 'DATE', "F" ) == "T" )
   cInputMask   := ::Clean( ::LeaDato( cName, 'INPUTMASK', "" ) )
   cFormat      := ::Clean( ::LeaDato( cName, 'FORMAT', "" ) )
   cOnEnter     := ::LeaDato( cName, 'ON ENTER', '' )
   cOnChange    := ::LeaDato( cName, 'ON CHANGE', '' )
   cOnGotFocus  := ::LeaDato( cName, 'ON GOTFOCUS', '' )
   cOnLostFocus := ::LeaDato( cName, 'ON LOSTFOCUS', '' )
   lReadonly    := ( ::LeaDatoLogic( cName, 'READONLY', "F" ) == "T" )
   nFocusedPos  := Val( ::LeaDato( cName, 'FOCUSEDPOS', '-2' ) )
   cValid       := ::LeaDato( cName, 'VALID', '' )
   cAction      := ::LeaDato( cName, 'ACTION', '' )
   cAction2     := ::LeaDato( cName, 'ACTION2', '' )
   cImage       := ::LeaDato( cName, 'IMAGE', '' )
   cWhen        := ::LeaDato( cName, 'WHEN', '' )
   lNoBorder    := ( ::LeaDatoLogic( cName, "NOBORDER", "F" ) == "T" )
   cSubClass    := ::LeaDato( cName, 'SUBCLASS', '' )
   lBold        := ( ::LeaDatoLogic( cName, 'BOLD', "F" ) == "T" )
   lBold        := ( Upper( ::LeaDato_Oop( cName, 'FONTBOLD', IF( lBold, '.T.', '.F.' ) ) ) == '.T.' )
   lItalic      := ( ::LeaDatoLogic( cName, 'ITALIC', "F" ) == "T" )
   lItalic      := ( Upper( ::LeaDato_Oop( cName, 'FONTITALIC', IF( lItalic, '.T.', '.F.' ) ) ) == '.T.' )
   lUnderline   := ( ::LeaDatoLogic( cName, 'UNDERLINE', "F" ) == "T" )
   lUnderline   := ( Upper( ::LeaDato_Oop( cName, 'FONTUNDERLINE', IF( lUnderline, '.T.', '.F.' ) ) ) == '.T.' )
   lStrikeout   := ( ::LeaDatoLogic( cName, 'STRIKEOUT', "F" ) == "T" )
   lStrikeout   := ( Upper( ::LeaDato_Oop( cName, 'FONTSTRIKEOUT', IF( lStrikeout, '.T.', '.F.' ) ) ) == '.T.' )
   aBackColor   := ::LeaDato( cName, 'BACKCOLOR', 'NIL' )
   aBackColor   := UpperNIL( ::LeaDato_Oop( cName, 'BACKCOLOR', aBackColor ) )
   lVisible     := ( ::LeaDatoLogic( cName, 'INVISIBLE', "F" ) == "F" )
   lVisible     := ( Upper( ::LeaDato_Oop( cName, 'VISIBLE', IF( lVisible, '.T.', '.F.' ) ) ) == '.T.' )
   lEnabled     := ( ::LeaDatoLogic( cName, 'DISABLED', "F" ) == "F" )
   lEnabled     := ( Upper( ::LeaDato_Oop( cName, 'ENABLED', IF( lEnabled, '.T.', '.F.' ) ) ) == '.T.' )
   aFontColor   := ::LeaDato( cName, 'FONTCOLOR', 'NIL' )
   aFontColor   := UpperNIL( ::LeaDato_Oop( cName, 'FONTCOLOR', aFontColor ) )
   lCenterAlign := ( ::LeaDatoLogic( cName, "CENTERALIGN", "F" ) == "T" )
   lRTL         := ( ::LeaDatoLogic( cName, 'RTL', "F" ) == "T" )
   lAutoSkip    :=  ( ::LeaDatoLogic( cName, 'AUTOSKIP', "F" ) == "T" )
   cOnTextFill  := ::LeaDato( cName, 'ON TEXTFILLED', '' )
   nDefaultYear := Val( ::LeaDato( cName, 'DEFAULTYEAR', '0' ) )
   nButtonWidth := Val( ::LeaDato( cName, 'BUTTONWIDTH', '0' ) )
   nInsertType  := Val( ::LeaDato( cName, 'INSERTTYPE', '0' ) )
   IF lDate .OR. Len( cInputMask ) > 0
      nMaxLength := 0
   ENDIF
   IF lUpperCase
      cValue := Upper( cValue )
      lLowerCase := .F.
   ELSEIF lLowerCase
      cValue := Lower( cValue )
   ENDIF

   // Save properties
   ::aCtrlType[i]      := 'TEXT'
   ::aName[i]          := cName
   ::aCObj[i]          := cObj
   ::aFontName[i]      := cFontName
   ::aFontSize[i]      := nFontSize
   ::avalue[i]         := cValue
   ::aField[i]         := cField
   ::aToolTip[i]       := cToolTip
   ::aMaxLength[i]     := nMaxLength
   ::aHelpID[i]        := nHelpId
   ::aUpperCase[i]     := lUpperCase
   ::aLowerCase[i]     := lLowerCase
   ::aPassWord[i]      := lPassword
   ::aNumeric[i]       := lNumeric
   ::aRightAlign[i]    := lRightAlign
   ::aNoTabStop[i]     := lNoTabStop
   ::aDate[i]          := lDate
   ::aInputMask[i]     := cInputMask
   ::aFields[i]        := cFormat
   ::aOnEnter[i]       := cOnEnter
   ::aOnChange[i]      := cOnChange
   ::aOnGotFocus[i]    := cOnGotFocus
   ::aOnLostFocus[i]   := cOnLostFocus
   ::aReadOnly[i]      := lReadonly
   ::aFocusedPos[i]    := nFocusedPos
   ::aValid[i]         := cValid
   ::aAction[i]        := cAction
   ::aAction2[i]       := cAction2
   ::aImage[i]         := cImage
   ::aWhen[i]          := cWhen
   ::aBorder[i]        := lNoBorder
   ::aSubClass[i]      := cSubClass
   ::aBold[i]          := lBold
   ::aFontItalic[i]    := lItalic
   ::aFontUnderline[i] := lUnderline
   ::aFontStrikeout[i] := lStrikeout
   ::aBackColor[i]     := aBackColor
   ::aVisible[i]       := lVisible
   ::aEnabled[i]       := lEnabled
   ::aFontColor[i]     := aFontColor
   ::aCenterAlign[i]   := lCenterAlign
   ::aRTL[i]           := lRTL
   ::aAutoPlay[i]      := lAutoSkip
   ::aOnTextFilled[i]  := cOnTextFill
   ::aDefaultYear[i]   := nDefaultYear
   ::aButtonWidth[i]   := nButtonWidth
   ::aInsertType[i]    := nInsertType

   // Create control
   @ nRow, nCol LABEL &cName OF ( ::oDesignForm:Name ) ;
      WIDTH nWidth ;
      HEIGHT nHeight ;
      VALUE "" ;
      ACTION ::Dibuja( This:Name ) ;
      BACKCOLOR WHITE ;
      CLIENTEDGE
   IF Len( cFontName ) > 0
      ::oDesignForm:&cName:FontName := cFontName
   ENDIF
   IF nFontSize > 0
      ::oDesignForm:&cName:FontSize := nFontSize
   ENDIF
   IF aFontColor # 'NIL'
      ::oDesignForm:&cName:FontColor := &aFontColor
   ENDIF
   ::oDesignForm:&cName:FontBold      := lBold
   ::oDesignForm:&cName:FontItalic    := lItalic
   ::oDesignForm:&cName:FontUnderline := lUnderline
   ::oDesignForm:&cName:FontStrikeout := lStrikeout
   IF IsValidArray( aBackColor )
      ::oDesignForm:&cName:BackColor := &aBackColor
   ENDIF
   ::oDesignForm:&cName:ToolTip := cToolTip

   ::AddCtrlToTabPage( i, cName, nRow, nCol )
RETURN NIL

// llena los TABS, previo cargado de los controles en la forma
//------------------------------------------------------------------------------
METHOD AddCtrlToTabPage( z, cName, nRow, nCol ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nStartLine, nPageCount, i, nPos, cTabName

   IF ::swTab
      nStartLine := ::aSpeed[z]
      nPageCount := 0

      FOR i := nStartLine TO 1 STEP -1
         IF At( Upper( 'END TAB' ), Upper( ::aLine[i] ) ) # 0
            RETURN NIL
         ENDIF

         IF At( Upper( 'DEFINE PAGE ' ), Upper( ::aLine[i] ) ) # 0
            nPageCount ++
         ELSE
            IF ( nPos := At( Upper( 'DEFINE TAB ' ), Upper( ::aLine[i] ) ) ) # 0
               cTabName := Lower( Alltrim( SubStr( ::aLine[i], nPos + 11 ) ) )
               IF RIGHT( cTabName, 1 ) == ";"
                  cTabName := AllTrim( SubStr( cTabName, 1, Len( cTabName ) - 1 ) )
               ENDIF
               EXIT
            ENDIF
         ENDIF
      NEXT i

      IF nPageCount > 0
         ::aTabPage[z, 1] := cTabName
         ::aTabPage[z, 2] := nPageCount
         ::oDesignForm:&(cTabName):AddControl( ::aControlW[z], nPageCount, nRow, nCol )
         IF ::aBackColor[z] == 'NIL'
            ::oDesignForm:&cName:BackColor := ::myIde:aSystemColorAux         // TODO: Check
         ENDIF
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD ProcesaControl( oCtrl ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oPage, oTab, nPos

   IF oCtrl:Row # oCtrl:ContainerRow .OR. oCtrl:Col # oCtrl:ContainerCol
      oPage      := oCtrl:Container
      oTab       := oPage:Container
      nPos       := oPage:Position
      oTab:Value := nPos
   ENDIF

   ::Dibuja( oCtrl:Name, .T. )
   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD RefreshControlInspector( ControlName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, aSelCtrl, aVal, cControl, cName, cType, nl, j, oControl, nRow, nCol, nWidth, nHeight
STATIC lBusy := .F.

   IF lBusy
      RETURN NIL
   ENDIF
   lBusy := .T.

   IF HB_IsString( ControlName ) .AND. ! Empty( ControlName )
      aSelCtrl := { Lower( ControlName ) }
   ELSE
      aSelCtrl := {}
      aVal := ::oCtrlList:Value
      FOR i := 1 to Len( aVal )
        aAdd( aSelCtrl, ::oCtrlList:Cell( aVal[i], 6 ) )
      NEXT i
   ENDIF

   ::oCtrlList:SetRedraw( .F. )

   ::oCtrlList:DeleteAllItems()
   FOR i := 2 TO Len( ::aName )
      IF Len( RTrim( ::aControlW[i] ) ) > 0
         cControl := Lower( ::aControlW[i] )
         cName := ::aName[i]
         cType := ::aCtrlType[i]
         nl := 0
         FOR j := 1 TO Len( ::oDesignForm:aControls )
            IF Lower( ::oDesignForm:aControls[j]:Name ) == cControl
               nl := j
               EXIT
            ENDIF
         NEXT j
         IF nl > 0
            oControl := ::oDesignForm:acontrols[nl]
            nRow := oControl:Row
            nCol := oControl:Col
            nWidth := oControl:Width
            nHeight := oControl:Height
            ::oCtrlList:AddItem( { cName, Str( nRow, 4 ), Str( nCol, 4 ), Str( nWidth, 4 ), Str( nHeight, 4 ), cControl, cType } )
         ENDIF
      ENDIF
   NEXT i

   aVal := {}
   IF Len( aSelCtrl ) > 0
      nl := ::oCtrlList:ItemCount
      FOR i := 1 TO nl
         j := aScan( aSelCtrl, ::oCtrlList:Cell( i, 6 ) )
         IF j > 0
            aAdd( aVal, i )
         ENDIF
      NEXT i
   ENDIF
   ::oCtrlList:Value := aVal

   SetHeightForWholeRows( ::oCtrlList, 400 )

   ::oCtrlList:SetRedraw( .T. )

   lBusy := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD DeleteControl() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL ia, j, l, jk, oControl, jcvc, cname, cNameW

   IF ::nControlW == 1
      RETURN NIL
   ENDIF

   ia := ::nHandleP
   IF ia > 0
      IF ::SiEsDEste( ia, 'TAB')
         oControl := ::oDesignForm:aControls[ia]
         IF oControl:hWnd > 0
            cName := Lower( oControl:Name )
            jk := aScan( ::aControlW, { |c| Lower( c ) == cName } )
            IF jk > 0
               cNameW := ::aName[jk]
               IF ! MsgYesNo( 'Are you sure you want to delete control ' + cNameW + ' ?', 'Question' )
                  RETURN NIL
               ENDIF
               l := ::nControlW
               FOR j := l TO 1 STEP -1
                  IF Lower( ::aTabPage[j, 1] ) == cName
                     ::IniArray( j, '', '', .T. )
                  ENDIF
               NEXT j
               ::IniArray( jk, '', '', .T. )
               ::oDesignForm:&cName:Release()
            ENDIF
         ENDIF
         ::lFsave := .F.
         EraseWindow( ::oDesignForm:Name )
         ::MisPuntos()
         ::RefreshControlInspector()
      ELSE
         oControl := ::oDesignForm:aControls[ia]
         cName := Lower( oControl:Name )
         jcvc := aScan( ::aControlW, { |c| Lower( c ) ==  cName } )
         IF jcvc > 1
            IF ! MsgYesNo( 'Are you sure you want to delete control ' + ::aName[jcvc] + ' ?', "OOHG IDE+" )
               RETURN NIL
            ENDIF
            ::oDesignForm:&cName:Release()
            ::IniArray( jcvc, '', '', .T. )
         ENDIF
         ::lFsave := .F.
         EraseWindow( ::oDesignForm:Name )
         ::Cordenada()
         ::MisPuntos()
         ::RefreshControlInspector()
      ENDIF
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD Cordenada() CLASS TFormEditor
//------------------------------------------------------------------------------
local iRow, iCol, iMin, w_OOHG_MouseRow, w_OOHG_MouseCol, i, cName, oControl

   iRow := _ooHG_mouserow
   iCol := _ooHG_mousecol
   ::Form_Main:labelyx:Value := StrZero( iRow, 4 ) + ',' + StrZero( iCol, 4 )

   iMin := 0

   w_OOHG_MouseRow = _OOHG_MouseRow  - GetBorderHeight()
   w_OOHG_MouseCol = _OOHG_MouseCol  - GetBorderWidth()

   For i := 2 To Len( ::aName )
      cName := ::aName[i]
      IF ValType( cName ) == 'C' .AND. ! Empty( cName ) .AND. ::aCtrlType[i] != 'STATUSBAR' .AND. aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == Lower( cName ) } ) > 0
         oControl := ::oDesignForm:&cName:Object()
         if ocontrol:hWnd > 0
            if ocontrol:row=ocontrol:containerrow .AND. ocontrol:col=ocontrol:containercol
               if ( w_ooHG_mouserow >= ocontrol:Row - 10 ) .AND. ;
                  ( w_ooHG_mouserow <= ocontrol:Row ) .AND. ;
                  ( w_ooHG_mousecol >= ocontrol:Col - 10 ) .AND. ;
                  ( w_ooHG_mousecol <= ocontrol:Col ) .AND. ;
                  ( .not. lower(ocontrol:name) $ 'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .AND. ;
                  ( .not. lower(ocontrol:type) $ 'hotkey' )
                  iMin := i
               EndIf
            else
               if ( w_ooHG_mouserow >= ocontrol:containerRow - 10 ) .AND. ;
                  ( w_ooHG_mouserow <= ocontrol:containerRow   )  .AND. ;
                  ( w_ooHG_mousecol >= ocontrol:containerCol - 10 ) .AND. ;
                  ( w_ooHG_mousecol <= ocontrol:containerCol ) .AND. ;
                  ( .not. lower(ocontrol:name) $ 'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .AND. ;
                  (  .not. lower(ocontrol:type) $ 'hotkey' )
                  iMin := i
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   Next i

   if iMin > 0
      CursorHand()
      ::swCursor := 1
      ::myHandle := iMin
   else
      if ::swCursor # 2
         CursorArrow()
         ::swCursor := 0
      endif
   endif

   Imin := 0
   For i := 2 To Len( ::aName )
      cName := ::aName[i]
      if valtype(cName) = 'C' .AND. cName # '' .AND. ! ::aCtrlType[i] $ 'STATUSBAR'
         oControl := ::oDesignForm:&cName:Object()
         if ocontrol:hWnd > 0
            if ! oControl:Type == 'TOOLBAR'
               if ocontrol:row=ocontrol:containerrow .AND. ocontrol:col=ocontrol:containercol
                  if ( w_ooHG_mouserow >= ocontrol:Row  + ocontrol:height ) .AND. ;
                     ( w_ooHG_mouserow <= ocontrol:Row + ocontrol:height+5 ) .AND. ;
                     ( w_ooHG_mousecol >= ocontrol:Col  + ocontrol:width ) .AND. ;
                     ( w_ooHG_mousecol <= ocontrol:Col + ocontrol:width+5 ) .AND. ;
                     ( .not. lower(ocontrol:name) $ 'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .AND. ;
                     ( .not. lower(ocontrol:type) $ 'hotkey' ) .AND. ;
                     ! ::aCtrlType[i] $ 'MONTHCALENDAR TIMER'
                     iMin := i
                  EndIf
               else
                  if ( w_ooHG_mouserow >= ocontrol:containerRow  + ocontrol:height ) .AND. ;
                     ( w_ooHG_mouserow <= ocontrol:containerRow + ocontrol:height+5 ) .AND. ;
                     ( w_ooHG_mousecol >= ocontrol:containerCol  + ocontrol:width ) .AND. ;
                     ( w_ooHG_mousecol <= ocontrol:containerCol + ocontrol:width+5 ) .AND. ;
                     ( .not. lower(ocontrol:name) $ 'dummymenuname events keyb statusbar statusitem timernum timercaps timerinsert statuskeybrd timerbar statustimer timer_cvctt' ) .AND. ;
                     ( .not. lower(ocontrol:type) $ 'hotkey' ) .AND. ;
                     ! ::aCtrlType[i] $ 'MONTHCALENDAR TIMER'
                     iMin := i
                  EndIf
               endif
            endif
         endif
      endif
   Next i

   if iMin > 0
      CursorSizeNWSE()
      ::swCursor := 2
      ::myHandle := iMin
   else
      if ::swCursor # 1
         CursorArrow()
         ::swCursor := 0
      endif
   endif
RETURN NIL

//------------------------------------------------------------------------------
METHOD Debug() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, cs := ''
   cs := cs + '# controles ' + Str( ::nControlW - 1, 4 ) + CRLF
   FOR i := 1 TO ::nControlW
       IF Upper( ::aControlW[i] ) # 'TEMPLATE' .AND. ;
          Upper( ::aControlW[i] ) # 'STATUSBAR' .AND. ;
          Upper( ::aControlW[i] ) # 'MAINMENU' .AND. ;
          Upper( ::aControlW[i] ) # 'CONTEXTMENU' .AND. ;
          Upper( ::aControlW[i] ) # 'NOTIFYMENU'
          IF ::aTabPage[i,1] # NIL .AND. ::aTabPage[i, 1] # ''
             cs := cs + ::aControlW[i] + ' | ' + ::aCtrlType[i] + ' | ' + Str( ::aTabPage[i, 2] )+ ' | ' + ::aTabPage[i, 1] + CRLF
          ELSE
             cs := cs + ::aControlW[i] + ' | ' + ::aCtrlType[i] + ' |-> ' + ::aCaption[i] + CRLF
          ENDIF
       ENDIF
   NEXT i
   MsgInfo( cs )
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION cHideControl( x )
//------------------------------------------------------------------------------
RETURN HideWindow( x )

//------------------------------------------------------------------------------
FUNCTION SetHeightForWholeRows( oGrid, nMaxHeight )
//------------------------------------------------------------------------------
LOCAL nAreaUsed, nItemHeight, nNewHeight
STATIC nOldHeight := 0

   nItemHeight := oGrid:ItemHeight()
   IF nItemHeight <= 0
      nNewHeight := nMaxHeight
   ELSE
      nAreaUsed := oGrid:HeaderHeight + ;
                   IF( IsWindowStyle( oGrid:hWnd, WS_HSCROLL ), ;
                       GetHScrollBarHeight(), ;
                       0 ) + ;
                   IF( IsWindowExStyle( oGrid:hWnd, WS_EX_CLIENTEDGE ), ;
                       GetEdgeHeight() * 2, ;
                       0 )
      nNewHeight := ( Int( ( nMaxHeight - nAreaUsed ) / nItemHeight ) * nItemHeight + nAreaUsed )
   ENDIF
   IF nNewHeight # nOldHeight
      oGrid:Height := nNewHeight
      nOldHeight := nNewHeight
   ENDIF
RETURN NIL

// saveform.prg
//------------------------------------------------------------------------------
METHOD Save( lSaveAs ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL BaseRow, BaseCol, Output, nSpacing := 3, aCaptions, aWidths, CurrentPage
LOCAL aActions, aIcons, aStyles, aToolTips, aAligns, i, j, cName, nCtrlPos, k
LOCAL nRow, nCol, nWidth, nHeight, caCaptions, caImages, caPageNames, caPageObjs
LOCAL caPageSubClasses, aImages, aPageNames, aPageObjs, aPageSubClasses

   CursorWait()
   ::oWaitMsg:label_1:Value := 'Saving form ...'

   BaseRow := GetWindowRow( ::oDesignForm:hWnd )
   BaseCol := GetWindowCol( ::oDesignForm:hWnd )

/*
   All keywords, properties and control names must be followed by a space.
*/

//***************************  Header
   Output := '' + CRLF
   Output += '* ooHG IDE Plus form generated code' + CRLF
   Output += '* (c)2003-2014 Ciro Vargas Clemow <pcman2010@yahoo.com > ' + CRLF
   Output += CRLF

//***************************  Form start
   Output += 'DEFINE WINDOW TEMPLATE ;' + CRLF
   // Must be always the second line
   Output += Space( nSpacing ) + 'AT ' + LTrim( Str( BaseRow ) ) + ', ' + LTrim( Str( BaseCol ) ) + ' ;' + CRLF
   Output += IIF( ! Empty( ::cfobj ), Space( nSpacing ) + 'OBJ ' + AllTrim( ::cfobj ) + " ;" + CRLF, '')
   Output += Space( nSpacing ) + 'WIDTH ' + LTrim( Str( GetWindowWidth( ::oDesignForm:hWnd ) ) ) + ' ;' + CRLF
   Output += Space( nSpacing ) + 'HEIGHT ' + LTrim( Str( GetWindowHeight( ::oDesignForm:hWnd ) ) )
   IF ! Empty( ::cFParent )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'PARENT ' + StrToStr( ::cFParent )
   ENDIF
   IF ::nfvirtualw > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'VIRTUAL WIDTH ' + LTrim( Str( ::nfvirtualw ) )
   ENDIF
   IF ::nfvirtualh > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'VIRTUAL HEIGHT ' + LTrim( Str( ::nfvirtualh ) )
   ENDIF
   IF ! Empty( ::cFTitle )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'TITLE ' + StrToStr( ::cFTitle )
   ENDIF
   IF ! Empty( ::cFIcon )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ICON ' + StrToStr( ::cFIcon )
   ENDIF
   Output += IIF( ::lfmain, ' ;' + CRLF + Space( nSpacing ) + 'MAIN ', '' )
   Output += IIF( ::lfsplitchild, ' ;' + CRLF + Space( nSpacing ) + 'SPLITCHILD ', '' )
   Output += IIF( ::lfchild, ' ;' + CRLF + Space( nSpacing ) + 'CHILD ', '' )
   Output += IIF( ::lfmodal, ' ;' + CRLF + Space( nSpacing ) + 'MODAL ', '' )
   Output += IIF( ::lfnoshow, ' ;' + CRLF + Space( nSpacing ) + 'NOSHOW ', '' )
   Output += IIF( ::lftopmost, ' ;' + CRLF + Space( nSpacing ) + 'TOPMOST ', '' )
   Output += IIF( ::lfnoautorelease, ' ;' + CRLF + Space( nSpacing ) + 'NOAUTORELEASE ', '' )
   Output += IIF( ::lfnominimize, ' ;' + CRLF + Space( nSpacing ) + 'NOMINIMIZE ', '' )
   Output += IIF( ::lfnomaximize, ' ;' + CRLF + Space( nSpacing ) + 'NOMAXIMIZE ', '' )
   Output += IIF( ::lfnosize, ' ;' + CRLF + Space( nSpacing ) + 'NOSIZE ', '' )
   Output += IIF( ::lfnosysmenu, ' ;' + CRLF + Space( nSpacing ) + 'NOSYSMENU ', '' )
   Output += IIF( ::lfnocaption, ' ;' + CRLF + Space( nSpacing ) + 'NOCAPTION ', '' )
   IF ! Empty( ::cfcursor )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'CURSOR ' + StrToStr( ::cfcursor )
   ENDIF
   IF ! Empty( ::cFOnInit )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON INIT ' + AllTrim( ::cFOnInit )
   ENDIF
   IF ! Empty( ::cFOnRelease )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RELEASE ' + AllTrim( ::cFOnRelease )
   ENDIF
   IF ! Empty( ::cFOnInteractiveClose )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON INTERACTIVECLOSE ' + AllTrim( ::cFOnInteractiveClose )
   ENDIF
   IF ! Empty( ::cFOnMouseClick )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOUSECLICK ' + AllTrim( ::cFOnMouseClick )
   ENDIF
   IF ! Empty( ::cFOnMouseDrag )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOUSEDRAG ' + AllTrim( ::cFOnMouseDrag )
   ENDIF
   IF ! Empty( ::cFOnMouseMove )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOUSEMOVE ' + AllTrim( ::cFOnMouseMove )
   ENDIF
   IF ! Empty( ::cFOnSize )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SIZE ' + AllTrim( ::cFOnSize )
   ENDIF
   IF ! Empty( ::cFOnPaint )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON PAINT ' + AllTrim( ::cFOnPaint )
   ENDIF
   IF ::cFBackcolor # 'NIL'
      Output += ' ;' + CRLF + Space( nSpacing ) + 'BACKCOLOR ' + ::cFBackcolor
   ENDIF
   IF ! Empty( ::cFFontName )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'FONT ' + StrToStr( ::cFFontName )
   ENDIF
   IF ::nFFontSize > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'SIZE ' + LTrim( Str( ::nFFontSize ) )
   ENDIF
   IF ::cFFontColor # 'NIL'
      Output += ' ;' + CRLF + Space( nSpacing ) + 'FONTCOLOR ' + ::cFFontColor
   ENDIF
   Output += IIF( ::lfgrippertext, ' ;' + CRLF + Space( nSpacing ) + 'GRIPPERTEXT ', '' )
   IF ! Empty( ::cfnotifyicon )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'NOTIFYICON ' + StrToStr( ::cfnotifyicon )
   ENDIF
   IF ! Empty( ::cfnotifytooltip )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'NOTIFYTOOLTIP ' + StrToStr( ::cfnotifytooltip )
   ENDIF
   IF ! Empty( ::cFOnNotifyClick )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON NOTIFYCLICK ' + AllTrim( ::cFOnNotifyClick )
   ENDIF
   Output += IIF( ::lfbreak, ' ;' + CRLF + Space( nSpacing ) + 'BREAK ', '')
   Output += IIF( ::lffocused, ' ;' + CRLF + Space( nSpacing ) + 'FOCUSED ', '')
   IF ! Empty( ::cFOnGotFocus )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON GOTFOCUS ' + AllTrim( ::cFOnGotFocus )
   ENDIF
   IF ! Empty( ::cFOnLostFocus )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON LOSTFOCUS ' + AllTrim( ::cFOnLostFocus )
   ENDIF
   IF ! Empty( ::cFOnScrollUp )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLUP ' + AllTrim( ::cFOnScrollUp )
   ENDIF
   IF ! Empty( ::cFOnScrollDown )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLDOWN ' + AllTrim( ::cFOnScrollDown )
   ENDIF
   IF ! Empty( ::cFOnScrollRight )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLRIGHT ' + AllTrim( ::cFOnScrollRight )
   ENDIF
   IF ! Empty( ::cFOnScrollLeft )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON SCROLLLEFT ' + AllTrim( ::cFOnScrollLeft )
   ENDIF
   IF ! Empty( ::cFOnHScrollbox )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON HSCROLLBOX ' + AllTrim( ::cFOnHScrollbox )
   ENDIF
   IF ! Empty( ::cFOnVScrollbox )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON VSCROLLBOX ' + AllTrim( ::cFOnVScrollbox )
   ENDIF
   Output += IIF( ::lfhelpbutton, ' ;' + CRLF + Space( nSpacing ) + 'HELPBUTTON ', '')
   IF ! Empty( ::cfonmaximize )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MAXIMIZE ' + AllTrim( ::cfonmaximize )
   ENDIF
   IF ! Empty( ::cfonminimize )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MINIMIZE ' + AllTrim( ::cfonminimize )
   ENDIF
   Output += IIF( ::lFModalSize, ' ;' + CRLF + Space( nSpacing ) + 'MODALSIZE ', '')
   Output += IIF( ::lFMDI, ' ;' + CRLF + Space( nSpacing ) + 'MDI ', '')
   Output += IIF( ::lFMDIClient, ' ;' + CRLF + Space( nSpacing ) + 'MDICLIENT ', '')
   Output += IIF( ::lFMDIChild, ' ;' + CRLF + Space( nSpacing ) + 'MDICHILD ', '')
   Output += IIF( ::lFInternal, ' ;' + CRLF + Space( nSpacing ) + 'INTERNAL ', '')
   IF ! Empty( ::cFMoveProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MOVE ' + AllTrim( ::cFMoveProcedure )
   ENDIF
   IF ! Empty( ::cFRestoreProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RESTORE ' + AllTrim( ::cFRestoreProcedure )
   ENDIF
   Output += IIF( ::lFRTL, ' ;' + CRLF + Space( nSpacing ) + 'RTL ', '')
   Output += IIF( ::lFClientArea, ' ;' + CRLF + Space( nSpacing ) + 'CLIENTAREA ', '')
   IF ! Empty( ::cFRClickProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RCLICK ' + AllTrim( ::cFRClickProcedure )
   ENDIF
   IF ! Empty( ::cFMClickProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MCLICK ' + AllTrim( ::cFMClickProcedure )
   ENDIF
   IF ! Empty( ::cFDblClickProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON DBLCLICK ' + AllTrim( ::cFDblClickProcedure )
   ENDIF
   IF ! Empty( ::cFRDblClickProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RDBLCLICK ' + AllTrim( ::cFRDblClickProcedure )
   ENDIF
   IF ! Empty( ::cFMDblClickProcedure )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON MDBLCLICK ' + AllTrim( ::cFMDblClickProcedure )
   ENDIF
   IF ::nFMinWidth > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'MINWIDTH ' + LTrim( Str( ::nFMinWidth ) )
   ENDIF
   IF ::nFMaxWidth > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'MAXWIDTH ' + LTrim( Str( ::nFMaxWidth ) )
   ENDIF
   IF ::nFMinHeight > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'MINHEIGHT ' + LTrim( Str( ::nFMinHeight ) )
   ENDIF
   IF ::nFMaxHeight > 0
      Output += ' ;' + CRLF + Space( nSpacing ) + 'MAXHEIGHT ' + LTrim( Str( ::nFMaxHeight ) )
   ENDIF
   IF ! Empty( ::cFBackImage )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'BACKIMAGE ' + StrToStr( ::cFBackImage )
      Output += IIF( ::lFStretch, ' ;' + CRLF + Space( nSpacing ) + 'STRETCH ', '')
   ENDIF
   IF ! Empty( ::cFSubClass )
      Output += ' ;' + CRLF + Space( nSpacing ) + 'ON RESTORE ' + AllTrim( ::cFSubClass )
   ENDIF
   Output += CRLF + CRLF

//***************************  Statusbar
   IF ::lSStat
      // Must end with a space
      Output += Space( nSpacing ) + 'DEFINE STATUSBAR '
      IF ! Empty( ::cSCObj )
         Output += ';' + CRLF + Space( nSpacing * 2 ) + 'OBJ ' + AllTrim( ::cSCObj )
      ENDIF
      IF ::lSTop
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'TOP '
      ENDIF
      IF ::lSNoAutoAdjust
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'NOAUTOADJUST '
      ENDIF
      IF ! Empty( ::cSSubClass )
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'SUBCLASS ' + AllTrim( ::cSSubClass )
      ENDIF
      IF ! Empty( ::cSFontName )
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'FONT ' + StrToStr( ::cSFontName )
      ENDIF
      IF ::nSFontSize > 0
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'SIZE ' + LTrim( Str( ::nSFontSize ) )
      ENDIF
      IF ::lSBold
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'BOLD '
      ENDIF
      IF ::lSItalic
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'ITALIC '
      ENDIF
      IF ::lSUnderline
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'UNDERLINE '
      ENDIF
      IF ::lSStrikeout
         Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'STRIKEOUT '
      ENDIF
      Output += CRLF + CRLF

      aCaptions := &( ::cSCaption )
      aWidths   := &( ::cSWidth )
      aActions  := &( ::cSAction )
      aIcons    := &( ::cSIcon )
      aStyles   := &( ::cSStyle )
      aToolTips := &( ::cSToolTip )
      aAligns   := &( ::cSAlign )
      FOR i := 1 TO Len( aCaptions )
         IF ! HB_IsString( aCaptions[i] ) .OR. Empty( aCaptions[i] )
            Output += Space( nSpacing * 2 ) + 'STATUSITEM ' + "' '"
         ELSE
            Output += Space( nSpacing * 2 ) + 'STATUSITEM ' + StrToStr( aCaptions[i] )
         ENDIF
         IF HB_IsNumeric( aWidths[i] ) .AND. aWidths[i] > 0
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( aWidths[i] ) )
         ENDIF
         IF HB_IsString( aActions[i] ) .AND. ! Empty( aActions[i] )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( aActions[i] )
         ENDIF
         IF HB_IsString( aIcons[i] ) .AND. ! Empty( aIcons[i] )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ICON ' + StrToStr( aIcons[i] )
         ENDIF
         IF HB_IsString( aStyles[i] )
            IF aStyles[i] == 'FLAT'
               Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'FLAT '
            ELSEIF aStyles[i] == 'RAISED'
               Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RAISED '
            ENDIF
         ENDIF
         IF HB_IsString( aToolTips[i] ) .AND. ! Empty( aToolTips[i] )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'TOOLTIP ' + StrToStr( aToolTips[i] )
         ENDIF
         IF HB_IsString( aAligns[i] )
            IF aAligns[i] == 'LEFT'
               Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'LEFT '
            ELSEIF aAligns[i] == 'RIGHT'
               Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RIGHT '
            ELSEIF aAligns[i] == 'CENTER'
               Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CENTER '
            ENDIF
         ENDIF
         Output += CRLF + CRLF
      NEXT i

      IF ::lSKeyboard
         Output += Space( nSpacing * 2 ) + 'KEYBOARD '
         IF ::nSKWidth > 0
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( ::nSKWidth ) )
         ENDIF
         IF ! Empty( ::cSKAction )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( ::cSKAction )
         ENDIF
         IF ! Empty( ::cSKToolTip )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'TOOLTIP ' + StrToStr( ::cSKToolTip )
         ENDIF
         IF ! Empty( ::cSKImage )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ICON ' + StrToStr( ::cSKImage )
         ENDIF
         IF ::cSKStyle == 'FLAT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'FLAT '
         ELSEIF ::cSKStyle == 'RAISED'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RAISED '
         ENDIF
         IF ::cSKAlign == 'LEFT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'LEFT '
         ELSEIF ::cSKAlign == 'RIGHT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RIGHT '
         ELSEIF ::cSKAlign == 'CENTER'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CENTER '
         ENDIF
         Output += CRLF + CRLF
      ENDIF

      IF ::lSDate
         Output += Space( nSpacing * 2 ) + 'DATE '
         IF ::nSDWidth > 0
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( ::nSDWidth ) )
         ENDIF
         IF ! Empty( ::cSDAction )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( ::cSDAction )
         ENDIF
         IF ! Empty( ::cSDToolTip )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'TOOLTIP ' + StrToStr( ::cSDToolTip )
         ENDIF
         IF ::cSDStyle == 'FLAT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'FLAT '
         ELSEIF ::cSDStyle == 'RAISED'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RAISED '
         ENDIF
         IF ::cSDAlign == 'LEFT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'LEFT '
         ELSEIF ::cSDAlign == 'RIGHT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RIGHT '
         ELSEIF ::cSDAlign == 'CENTER'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CENTER '
         ENDIF
         Output += CRLF + CRLF
      ENDIF

      IF ::lSTime
         Output += Space( nSpacing * 2 ) + 'CLOCK '
         IF ::nSCWidth > 0
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'WIDTH ' + LTrim( Str( ::nSCWidth ) )
         ENDIF
         IF ! Empty( ::cSCAction )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ACTION ' + AllTrim( ::cSCAction )
         ENDIF
         IF ! Empty( ::cSCToolTip )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'TOOLTIP ' + StrToStr( ::cSCToolTip )
         ENDIF
         IF ! Empty( ::cSCImage )
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'ICON ' + StrToStr( ::cSCImage )
         ENDIF
         IF ::lSCAmPm
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'AMPM '
         ENDIF
         IF ::cSCStyle == 'FLAT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'FLAT '
         ELSEIF ::cSCStyle == 'RAISED'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RAISED '
         ENDIF
         IF ::cSCAlign == 'LEFT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'LEFT '
         ELSEIF ::cSCAlign == 'RIGHT'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'RIGHT '
         ELSEIF ::cSCAlign == 'CENTER'
            Output += ' ;' + CRLF + Space( nSpacing * 3 ) + 'CENTER '
         ENDIF
         Output += CRLF + CRLF
      ENDIF

      Output += Space( nSpacing ) + 'END STATUSBAR '
      Output += CRLF + CRLF
   ENDIF

   //***************************  Main menu
   Output += TMyMenuEditor():FmgOutput( Self, 1, nSpacing )

   //***************************  Context menu
   Output += TMyMenuEditor():FmgOutput( Self, 2, nSpacing )

//***************************  Notify menu
   Output += TMyMenuEditor():FmgOutput( Self, 3, nSpacing )

   //***************************  Toolbar
   Output += ::myTbEditor:FmgOutput( nSpacing )

   //***************************  Form's controls
   j := 1
   DO WHILE j <= ::nControlW
      IF Upper( ::aControlW[j] ) == 'TEMPLATE' .OR. ;
         Upper( ::aControlW[j] ) == 'STATUSBAR' .OR. ;
         Upper( ::aControlW[j] ) == 'MAINMENU' .OR. ;
         Upper( ::aControlW[j] ) == 'CONTEXTMENU' .OR. ;
         Upper( ::aControlW[j] ) == 'NOTIFYMENU'
         j ++
         LOOP
      ENDIF
      cName := ::aControlW[j]
      nCtrlPos := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == Lower( cName ) } )
      IF nCtrlPos == 0
         j ++
         LOOP
      ENDIF
      nRow    := GetWindowRow( ::oDesignForm:acontrols[nCtrlPos]:hWnd ) - BaseRow - GetTitleHeight() - GetBorderHeight()
      nCol    := GetWindowCol( ::oDesignForm:acontrols[nCtrlPos]:hWnd ) - BaseCol - GetBorderWidth()
      nWidth  := GetWindowWidth( ::oDesignForm:acontrols[nCtrlPos]:hWnd )
      nHeight := GetWindowHeight( ::oDesignForm:acontrols[nCtrlPos]:hWnd )

      //***************************  Tab start
      IF ::aCtrlType[j] == 'TAB'
         // Do not delete next line, it's needed to load the fmg properly.
         Output += Space( nSpacing ) + '*****@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TAB ' + AllTrim( ::aName[j] ) + ' ;' + CRLF
         Output += Space( nSpacing ) + 'DEFINE TAB ' + AllTrim( ::aName[j] ) + ' ;' + CRLF
         IF ! Empty( ::aCObj[j] )
            Output += Space( nSpacing * 2 ) + 'OBJ ' + ::aCObj[j] + ' ;' + CRLF
         ENDIF
         Output += Space( nSpacing * 2 ) + 'AT ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' ;' + CRLF
         Output += Space( nSpacing * 2 ) + 'WIDTH ' + LTrim( Str( nWidth ) ) + ' ;' + CRLF
         Output += Space( nSpacing * 2 ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
         IF ! Empty( ::avalue[j] )
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'VALUE ' + AllTrim( ::avalue[j] )
         ENDIF
         IF ! Empty( ::aFontName[j] )
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'FONT ' + StrToStr( ::aFontName[j] )
         ENDIF
         IF ::aFontSize[j] > 0
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
         ENDIF
         IF ! Empty( ::aToolTip[j] )
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
         ENDIF
         IF ::aButtons[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'BUTTONS '
         ENDIF
         IF ::aFlat[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'FLAT '
         ENDIF
         IF ::ahottrack[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'HOTTRACK '
         ENDIF
         IF ::aVertical[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'VERTICAL '
         ENDIF
         IF ! Empty( ::aOnChange[j] )
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'ON CHANGE ' + ::aOnChange[j]
         ENDIF
         IF ::aBold[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'BOLD '
         ENDIF
         IF ::aFontItalic[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'ITALIC '
         ENDIF
         IF ::aFontUnderline[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'UNDERLINE '
         ENDIF
         IF ::aFontStrikeout[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'STRIKEOUT '
         ENDIF
         IF ::anotabstop[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'NOTABSTOP '
         ENDIF
         IF ::aRTL[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'RTL '
         ENDIF
         IF ! ::aEnabled[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'DISABLED '
         ENDIF
         IF ! ::aVisible[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'INVISIBLE '
         ENDIF
         IF ::aMultiLine[j]
           Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'MULTILINE '
         ENDIF
         IF ! Empty( ::aSubClass[j] )
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
         ENDIF
         IF ::aVirtual[j]
            Output += ' ;' + CRLF + Space( nSpacing * 2 ) + 'INTERNALS '
         ENDIF
         Output += CRLF + CRLF

         //***************************  Tab pages
         caCaptions       := ::aCaption[j]
         caImages         := ::aImage[j]
         caPageNames      := ::aPageNames[j]
         caPageObjs       := ::aPageObjs[j]
         caPageSubClasses := ::aPageSubClasses[j]
         aCaptions        := &caCaptions
         aImages          := &caImages
         aPageNames       := &caPageNames
         aPageObjs        := &caPageObjs
         aPageSubClasses  := &caPageSubClasses

         CurrentPage := 1
         Output += Space( nSpacing * 2) + 'DEFINE PAGE ' + StrToStr( aCaptions[currentpage] )
         IF ! Empty( aImages[CurrentPage] )
            Output += ' ;' + CRLF + Space( nSpacing * 3) + 'IMAGE ' + StrToStr( aImages[currentpage] )
         ENDIF
         IF ! Empty( aPageNames[CurrentPage] )
            Output += ' ;' + CRLF + Space( nSpacing * 3) + 'NAME ' + AllTrim( aPageNames[CurrentPage] )
         ENDIF
         IF ! Empty( aPageObjs[CurrentPage] )
            Output += ' ;' + CRLF + Space( nSpacing * 3) + 'OBJ ' + AllTrim( aPageObjs[CurrentPage] )
         ENDIF
         IF ! Empty( aPageSubClasses[CurrentPage] )
            Output += ' ;' + CRLF + Space( nSpacing * 3) + 'SUBCLASS ' + AllTrim( aPageSubClasses[CurrentPage] )
         ENDIF
         Output += CRLF + CRLF

         FOR k := 1 TO ::nControlW
            IF ::aTabPage[k, 1] # NIL
               IF ::aTabPage[k, 1] == ::aControlW[j]
                  IF ::aTabPage[k, 2] # CurrentPage
                     Output += Space( nSpacing * 2) + 'END PAGE ' + CRLF + CRLF
                     CurrentPage ++

                     Output += Space( nSpacing * 2) + 'DEFINE PAGE ' + StrToStr( aCaptions[CurrentPage] )
                     IF ! Empty( aImages[CurrentPage] )
                        Output += ' ;' + CRLF + Space( nSpacing * 3) + 'IMAGE ' + StrToStr( aImages[currentpage] )
                     ENDIF
                     IF ! Empty( aPageNames[CurrentPage] )
                        Output += ' ;' + CRLF + Space( nSpacing * 3) + 'NAME ' + AllTrim( aPageNames[CurrentPage] )
                     ENDIF
                     IF ! Empty( aPageObjs[CurrentPage] )
                        Output += ' ;' + CRLF + Space( nSpacing * 3) + 'OBJ ' + AllTrim( aPageObjs[CurrentPage] )
                     ENDIF
                     IF ! Empty( aPageSubClasses[CurrentPage] )
                        Output += ' ;' + CRLF + Space( nSpacing * 3) + 'SUBCLASS ' + AllTrim( aPageSubClasses[CurrentPage] )
                     ENDIF
                     Output += CRLF + CRLF
                  ENDIF

                  //***************************  Tab page controls
                  nCtrlPos := aScan( ::oDesignForm:aControls, { |c| Lower( c:Name ) == Lower( ::aControlW[k] ) } )
                  IF nCtrlPos > 0
                     nRow    := ::oDesignForm:aControls[nCtrlPos]:Row
                     nCol    := ::oDesignForm:aControls[nCtrlPos]:Col
                     nWidth  := ::oDesignForm:aControls[nCtrlPos]:Width
                     nHeight := ::oDesignForm:aControls[nCtrlPos]:Height
                     Output  := ::MakeControls( k, Output, nRow, nCol, nWidth, nHeight, nSpacing, 3)
                  ENDIF
               ENDIF
            ENDIF
         NEXT k

         Output += Space( nSpacing * 2) + 'END PAGE ' + CRLF + CRLF

         //***************************  Tab end
         Output += Space( nSpacing ) + "END TAB " + CRLF + CRLF
      ELSE
         //***************************  Other controls
         IF ::aCtrlType[j] # 'TAB' .AND. ( ::aTabPage[j, 2] == NIL .OR. ::aTabPage[j, 2] == 0 )
            Output := ::MakeControls( j, Output, nRow, nCol, nWidth, nHeight, nSpacing, 1 )
         ENDIF
      ENDIF
      j ++
   ENDDO

   //***************************  Form's end
   Output += 'END WINDOW ' + CRLF + CRLF
   Output := StrTran( Output, "  ;", " ;" )

   ::oWaitMsg:Hide()
   CursorArrow()

   //***************************  Save FMG
   IF lSaveAs == 1
      IF ! HB_MemoWrit( PutFile( { { 'Form files *.fmg', '*.fmg' } }, 'Save Form As', , .T. ), Output )
         MsgStop( 'Error writing FMG file.', 'OOHG IDE+' )
         RETURN NIL
      ENDIF
   ELSE
      IF ! HB_MemoWrit( ::cForm, Output )
         MsgStop( 'Error writing ' + ::cForm + ".", 'OOHG IDE+' )
         RETURN NIL
      ENDIF
      ::lFSave := .T.
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION StrToStr( cData )
//------------------------------------------------------------------------------
LOCAL cRet

   IF ! "'" $ cData
      cRet := "'" + AllTrim( cData ) + "'"
   ELSEIF ! '"' $ cData
      cRet := '"' + AllTrim( cData ) + '"'
   ELSEIF ! '[' $ cData .AND. ! ']' $ cData
      cRet := '[' + AllTrim( cData ) + ']'
   ELSE
      cRet := "'" + AllTrim( cData ) + "'"    // The FMG will throw a compiler error because cRet is malformed !!!
   ENDIF
RETURN cRet

//------------------------------------------------------------------------------
METHOD MakeControls( j, Output, nRow, nCol, nWidth, nHeight, nSpacing, nLevel ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cValue

   IF ::aCtrlType[j] == 'BROWSE'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' BROWSE ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aHeaders[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + AllTrim( ::aHeaders[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + "{ '', '' }"
      ENDIF
      IF ! Empty( ::aWidths[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + AllTrim( ::aWidths[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + "{ 90, 60 }"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WORKAREA ' + AllTrim( ::aWorkArea[j] )
      IF ! Empty( ::aFields[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELDS ' + AllTrim( ::aFields[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELDS ' + "{ 'field1', 'field2' }"
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aInputMask[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( ::aInputMask[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicBackColor[j] ) ) .AND. UpperNIL( ::aDynamicBackColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBACKCOLOR ' + AllTrim( ::aDynamicBackColor[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicForeColor[j] ) ) .AND. UpperNIL( ::aDynamicForeColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICFORECOLOR ' + AllTrim( ::aDynamicForeColor[j] )
      ENDIF
      IF ! Empty( ::aColumnControls[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNCONTROLS ' + AllTrim( ::aColumnControls[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( ::aOnDblClick[j] )
      ENDIF
      IF ! Empty( ::aOnHeadClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADCLICK ' + AllTrim( ::aOnHeadClick[j] )
      ENDIF
      IF ! Empty( ::aOnEditCell[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON EDITCELL ' + AllTrim( ::aOnEditCell[j] )
      ENDIF
      IF ! Empty( ::aOnAppend[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON APPEND ' + AllTrim( ::aOnAppend[j] )
      ENDIF
      IF ! Empty( ::aWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( ::aWhen[j] )
      ENDIF
      IF ! Empty( ::avalid[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( ::avalid[j] )
      ENDIF
      IF ! Empty( ::aValidMess[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALIDMESSAGES ' + AllTrim( ::aValidMess[j] )
      ENDIF
      IF ! Empty( ::aReadOnlyB[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY ' + AllTrim( ::aReadOnlyB[j] )
      ENDIF
      IF ::aLock[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LOCK '
      ENDIF
      IF ::aDelete[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DELETE '
      ENDIF
      IF ::aInPlace[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPLACE '
      ENDIF
      IF ::aEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDIT '
      ENDIF
      IF ::anolines[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLINES '
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'JUSTIFY ' + AllTrim( ::aJustify[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aAppend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'APPEND '
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aFull[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FULLMOVE '
      ENDIF
      IF ::aButtons[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'USEBUTTONS '
      ENDIF
      IF ::aNoHeaders[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHEADERS '
      ENDIF
      IF ! Empty( ::aHeaderImages[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERIMAGES ' + AllTrim( ::aHeaderImages[j] )
      ENDIF
      IF ! Empty( ::aImagesAlign[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESALIGN ' + AllTrim( ::aImagesAlign[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aSelColor[j] ) ) .AND. UpperNIL( ::aSelColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELECTEDCOLORS ' + AllTrim( ::aSelColor[j] )
      ENDIF
      IF ! Empty( ::aEditKeys[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDITKEYS ' + AllTrim( ::aEditKeys[j] )
      ENDIF
      IF ::aDoubleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DOUBLEBUFFER '
      ENDIF
      IF ::aSingleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SINGLEBUFFER '
      ENDIF
      IF ::aFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSRECT '
      ENDIF
      IF ::aNoFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOFOCUSRECT '
      ENDIF
      IF ::aPLM[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PAINTLEFTMARGIN '
      ENDIF
      IF ::aFixedCols[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCOLS '
      ENDIF
      IF ! Empty( ::aOnAbortEdit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ABORTEDIT ' + AllTrim( ::aOnAbortEdit[j] )
      ENDIF
      IF ::aFixedWidths[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDWIDTHS '
      ENDIF
      IF ! Empty( ::aBeforeColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLMOVE ' + AllTrim( ::aBeforeColMove[j] )
      ENDIF
      IF ! Empty( ::aAfterColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLMOVE ' + AllTrim( ::aAfterColMove[j] )
      ENDIF
      IF ! Empty( ::aBeforeColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLSIZE ' + AllTrim( ::aBeforeColSize[j] )
      ENDIF
      IF ! Empty( ::aAfterColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLSIZE ' + AllTrim( ::aAfterColSize[j] )
      ENDIF
      IF ! Empty( ::aBeforeAutoFit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFOREAUTOFIT ' + AllTrim( ::aBeforeAutoFit[j] )
      ENDIF
      IF ::aLikeExcel[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'EDITLIKEEXCEL '
      ENDIF
      IF ! Empty( ::aDeleteWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEWHEN ' + AllTrim( ::aDeleteWhen[j] )
      ENDIF
      IF ! Empty( ::aDeleteMsg[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEMSG ' + AllTrim( ::aDeleteMsg[j] )
      ENDIF
      IF ! Empty( ::aOnDelete[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DELETE ' + AllTrim( ::aOnDelete[j] )
      ENDIF
      IF ::aNoDelMsg[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'NODELETEMSG '
      ENDIF
      IF ::aFixedCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCONTROLS '
      ENDIF
      IF ::aDynamicCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICCONTROLS '
      ENDIF
      IF ! Empty( ::aOnHeadRClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADRCLICK ' + AllTrim( ::aOnHeadRClick[j] )
      ENDIF
      IF ::aExtDblClick[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EXTDBLCLICK '
      ENDIF
      IF ::anovscroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF ::aNoRefresh[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOREFRESH '
      ENDIF
      IF ! Empty( ::aReplaceField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'REPLACEFIELD ' + AllTrim( ::aReplaceField[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ::aRecCount[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RECCOUNT '
      ENDIF
      IF ! Empty( ::aColumnInfo[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNINFO ' + AllTrim( ::aColumnInfo[j] )
      ENDIF
      IF ::aDescend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DESCENDING '
      ENDIF
      IF ::aForceRefresh[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCEREFRESH '
      ENDIF
      IF ::aSync[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SYNCHRONIZED '
      ELSEIF ::aUnSync[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNSYNCHRONIZED '
      ENDIF
      IF ::aUpdate[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDATEALL '
      ENDIF
      IF ::aFixBlocks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDBLOCKS '
      ELSEIF ::aDynBlocks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBLOCKS '
      ENDIF
      IF ::aUpdateColors[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDATECOLORS '
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'BUTTON'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' BUTTON ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aCaption[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + StrToStr( ::aCaption[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + StrToStr( ::aName[j] )
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + StrToStr( ::aPicture[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ELSE
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + "MsgInfo( 'Button Pressed' )"
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aFlat[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FLAT '
      ENDIF
      IF ! Empty( ::aJustify[j] ) .AND. ! Empty( ::aPicture[j] ) .AND. ! Empty( ::aCaption[j] )
          // Must end with a space
          Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + Upper( AllTrim( ::aJustify[j] ) ) + " "
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnMouseMove[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON MOUSEMOVE ' + AllTrim( ::aOnMouseMove[j] )
      ENDIF
      IF ::anotabstop[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aHelpID[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aBuffer[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ! Empty( ::aImageMargin[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGEMARGIN ' + AllTrim( ::aImageMargin[j] )
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aNoPrefix[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOPREFIX '
      ENDIF
      IF ::aNoLoadTrans[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aForceScale[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCESCALE '
      ENDIF
      IF ::aCancel[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CANCEL '
      ENDIF
      IF ::aMultiLine[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MULTILINE '
      ENDIF
      IF ::aThemed[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ::aNo3DColors[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aFit[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOFIT '
      ENDIF
      IF ::aDIBSection[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DIBSECTION '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'CHECKBTN'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' CHECKBUTTON ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aCaption[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + StrToStr( ::aCaption[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + StrToStr( ::aName[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ::avaluel[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .T.'
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .F.'
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + StrToStr( ::aPicture[j] )
      ENDIF
      IF ! Empty( ::aBuffer[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ::aNoLoadTrans[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aForceScale[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCESCALE '
      ENDIF
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ::aNo3DColors[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aFit[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOFIT '
      ENDIF
      IF ::aDIBSection[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DIBSECTION '
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'CHECKBOX'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' CHECKBOX ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aCaption[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + StrToStr( ::aCaption[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CAPTION ' + "'" + "'"
      ENDIF
      IF ::avaluel[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .T.'
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .F.'
      ENDIF
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
       ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aHelpID[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSIZE '
      ENDIF
      IF ::aThemed[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ::aLeft[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LEFTALIGN '
      ENDIF
      IF ::a3State[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THREESTATE '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'COMBO'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' COMBOBOX ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      // Do not include HEIGHT
      IF ! Empty( ::aItems[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMS ' + AllTrim( ::aItems[j] )
      ENDIF
      IF ! Empty( ::aItemSource[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMSOURCE ' + AllTrim( ::aItemSource[j] )
      ENDIF
      IF ::avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::avaluen[j] ) )
      ENDIF
      IF ! Empty( ::avaluesource[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUESOURCE ' + AllTrim( ::avaluesource[j] )
      ENDIF
      IF ::aDisplayEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISPLAYEDIT '
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ! Empty( ::aOnDisplayChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DISPLAYCHANGE ' + AllTrim( ::aOnDisplayChange[j] )
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
/*
   TODO: Add SPLITBOX support
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
*/
      IF ::aSort[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SORT '
      ENDIF
      IF ! Empty( ::aItemImageNumber[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMIMAGENUMBER ' + AllTrim( ::aItemImageNumber[j] )
      ENDIF
      IF ! Empty( ::aImageSource[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESOURCE ' + AllTrim( ::aImageSource[j] )
      ENDIF
      IF ::aFirstItem[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIRSTITEM '
      ENDIF
      IF ::aListWidth[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LISTWIDTH ' + LTrim( Str( ::aListWidth[j] ) )
      ENDIF
      IF ! Empty( ::aOnListDisplay[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LISTDISPLAY ' + AllTrim( ::aOnListDisplay[j] )
      ENDIF
      IF ! Empty( ::aOnListClose[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LISTCLOSE ' + AllTrim( ::aOnListClose[j] )
      ENDIF
      IF ::aDelayedLoad[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DELAYEDLOAD '
      ENDIF
      IF ::aIncremental[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INCREMENTAL '
      ENDIF
      IF ::aIntegralHeight[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INTEGRALHEIGHT '
      ENDIF
      IF ::aRefresh[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'REFRESH '
      ENDIF
      IF ::aNoRefresh[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOREFRESH '
      ENDIF
      IF ! Empty( ::aSourceOrder[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SOURCEORDER ' + AllTrim( ::aSourceOrder[j] )
      ENDIF
      IF ! Empty( ::aOnRefresh[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON REFRESH ' + AllTrim( ::aOnRefresh[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ::aSearchLapse[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SEARCHLAPSE ' + LTrim( Str( ::aSearchLapse[j] ) )
      ENDIF
/*
   TODO: Add SPLITBOX support
      IF ! Empty( ::aGripperText[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'GRIPPERTEXT ' + AllTrim( ::aGripperText[j] )
      ENDIF
*/
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + AllTrim( ::aFontColor[j] )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aTextHeight[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TEXTHEIGHT ' + LTrim( Str( ::aTextHeight[j] ) )
      ENDIF
      IF ::aFit[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIT '
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'DATEPICKER'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' DATEPICKER ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::avalue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( ::avalue[j] )
      ENDIF
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + StrToStr( ::aField[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aShowNone[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWNONE '
      ENDIF
      IF ::aUpDown[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDOWN '
      ENDIF
      IF ::aRightAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBorder[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBORDER '
      ENDIF
      IF ! Empty( ::aRange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( ::aRange[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'TIMEPICKER'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TIMEPICKER ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::avalue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( ::avalue[j] )
      ENDIF
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + StrToStr( ::aField[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aShowNone[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWNONE '
      ENDIF
      IF ::aUpDown[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDOWN '
      ENDIF
      IF ::aRightAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBorder[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBORDER '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'EDIT'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' EDITBOX ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ! Empty( ::avalue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( ::avalue[j] )
      ENDIF
      IF ::aReadOnly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aMaxLength[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MAXLENGTH ' + LTrim( Str( ::aMaxLength[j] ) )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
/*
   TODO: Add SPLITBOX support
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
*/
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::anovscroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF ::aNoHScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHSCROLL '
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aBorder[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBORDER '
      ENDIF
      IF ::aFocusedPos[j] <> -4            // default value, see DATA nOnFocusPos in h_editbox.prg
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSEDPOS ' + LTrim( Str( ::aFocusedPos[j] ) )
      ENDIF
      IF ! Empty( ::aOnHScroll[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HSCROLL ' + AllTrim( ::aOnHScroll[j] )
      ENDIF
      IF ! Empty( ::aOnVScroll[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON VSCROLL ' + AllTrim( ::aOnVScroll[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'FRAME'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' FRAME ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "CAPTION " + StrToStr( ::aCaption[j] )
      IF ::aOpaque[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OPAQUE '
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + AllTrim( ::aBackColor[j] )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'GRID'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' GRID ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + AllTrim( ::aHeaders[j] )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + AllTrim( ::aWidths[j] )
      IF ! Empty( ::aItems[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMS ' + AllTrim( ::aItems[j] )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicBackColor[j] ) ) .AND. UpperNIL( ::aDynamicBackColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBACKCOLOR ' + AllTrim( ::aDynamicBackColor[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicForeColor[j] ) ) .AND. UpperNIL( ::aDynamicForeColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICFORECOLOR ' + AllTrim( ::aDynamicForeColor[j] )
      ENDIF
      IF ! Empty( ::aColumnControls[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNCONTROLS ' + AllTrim( ::aColumnControls[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( ::aOnDblClick[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] ) + ' ;' +CRLF
      ENDIF
      IF ! Empty( ::aOnHeadClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADCLICK ' + AllTrim( ::aOnHeadClick[j] )
      ENDIF
      IF ! Empty( ::aOnEditCell[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON EDITCELL ' + AllTrim( ::aOnEditCell[j] )
      ENDIF
      IF ::aMultiSelect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MULTISELECT '
      ENDIF
      IF ::anolines[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLINES '
      ENDIF
      IF ::aInPlace[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPLACE '
      ENDIF
      IF ::aEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDIT '
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'JUSTIFY ' + AllTrim( ::aJustify[j] )
      ENDIF
      IF ! Empty( ::aWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( ::aWhen[j] )
      ENDIF
      IF ! Empty( ::avalid[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( ::avalid[j] )
      ENDIF
      IF ! Empty( ::aValidMess[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALIDMESSAGES ' + AllTrim( ::aValidMess[j] )
      ENDIF
      IF ! Empty( ::aReadOnlyB[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY ' + AllTrim( ::aReadOnlyB[j] )
      ENDIF
      IF ! Empty( ::aInputMask[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( ::aInputMask[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aFull[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FULLMOVE '
      ENDIF
      IF ::aCheckBoxes[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CHECKBOXES '
      ENDIF
      IF ! Empty( ::aOnCheckChg[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHECKCHANGE ' + AllTrim( ::aOnCheckChg[j] )
      ENDIF
      IF ::aButtons[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'USEBUTTONS '
      ENDIF
      IF ::aDelete[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DELETE '
      ENDIF
      IF ::aAppend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'APPEND '
      ENDIF
      IF ! Empty( ::aOnAppend[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON APPEND ' + AllTrim( ::aOnAppend[j] )
      ENDIF
      IF ::aVirtual[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VIRTUAL '
      ENDIF
      IF ::aItemCount[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMCOUNT ' + LTrim( Str( ::aItemCount[j] ) )
      ENDIF
      IF ! Empty( ::aOnQueryData[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON QUERYDATA ' + AllTrim( ::aOnQueryData[j] )
      ENDIF
      IF ::aNoHeaders[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHEADERS '
      ENDIF
      IF ! Empty( ::aHeaderImages[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERIMAGES ' + AllTrim( ::aHeaderImages[j] )
      ENDIF
      IF ! Empty( ::aImagesAlign[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESALIGN ' + AllTrim( ::aImagesAlign[j] )
      ENDIF
      IF ::aByCell[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NAVIGATEBYCELL '
      ENDIF
      IF ! Empty( AllTrim( ::aSelColor[j] ) ) .AND. UpperNIL( ::aSelColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELECTEDCOLORS ' + AllTrim( ::aSelColor[j] )
      ENDIF
      IF ! Empty( ::aEditKeys[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDITKEYS ' + AllTrim( ::aEditKeys[j] )
      ENDIF
      IF ::aDoubleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DOUBLEBUFFER '
      ENDIF
      IF ::aSingleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SINGLEBUFFER '
      ENDIF
      IF ::aFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSRECT '
      ENDIF
      IF ::aNoFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOFOCUSRECT '
      ENDIF
      IF ::aPLM[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PAINTLEFTMARGIN '
      ENDIF
      IF ::aFixedCols[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCOLS '
      ENDIF
      IF ! Empty( ::aOnAbortEdit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ABORTEDIT ' + AllTrim( ::aOnAbortEdit[j] )
      ENDIF
      IF ::aFixedWidths[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDWIDTHS '
      ENDIF
      IF ! Empty( ::aBeforeColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLMOVE ' + AllTrim( ::aBeforeColMove[j] )
      ENDIF
      IF ! Empty( ::aAfterColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLMOVE ' + AllTrim( ::aAfterColMove[j] )
      ENDIF
      IF ! Empty( ::aBeforeColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLSIZE ' + AllTrim( ::aBeforeColSize[j] )
      ENDIF
      IF ! Empty( ::aAfterColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLSIZE ' + AllTrim( ::aAfterColSize[j] )
      ENDIF
      IF ! Empty( ::aBeforeAutoFit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFOREAUTOFIT ' + AllTrim( ::aBeforeAutoFit[j] )
      ENDIF
      IF ::aLikeExcel[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'EDITLIKEEXCEL '
      ENDIF
      IF ! Empty( ::aDeleteWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEWHEN ' + AllTrim( ::aDeleteWhen[j] )
      ENDIF
      IF ! Empty( ::aDeleteMsg[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEMSG ' + AllTrim( ::aDeleteMsg[j] )
      ENDIF
      IF ! Empty( ::aOnDelete[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DELETE ' + AllTrim( ::aOnDelete[j] )
      ENDIF
      IF ::aNoDelMsg[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'NODELETEMSG '
      ENDIF
      IF ::aNoModalEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'NOMODALEDIT '
      ENDIF
      IF ::aFixedCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCONTROLS '
      ENDIF
      IF ::aDynamicCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICCONTROLS '
      ENDIF
      IF ! Empty( ::aOnHeadRClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADRCLICK ' + AllTrim( ::aOnHeadRClick[j] )
      ENDIF
      IF ::aNoClickOnCheck[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOCLICKONCHECKBOX '
      ENDIF
      IF ::aNoRClickOnCheck[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NORCLICKONCHECKBOX '
      ENDIF
      IF ::aExtDblClick[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EXTDBLCLICK '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'HYPERLINK'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' HYPERLINK ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::avalue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( ::avalue[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + "'ooHG Home'"
      ENDIF
      IF ! Empty( ::aAddress[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ADDRESS ' + StrToStr( ::aAddress[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ADDRESS ' + "'https://sourceforge.net/projects/oohg/'"
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aHandCursor[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HANDCURSOR '
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSIZE '
      ENDIF
      IF ::aBorder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDER '
      ENDIF
      IF ::aClientEdge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF ::aNoHScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HSCROLL '
      ENDIF
      IF ::aNoVScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VSCROLL '
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'IMAGE'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' IMAGE ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + StrToStr( ::aPicture[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "PICTURE 'oohg.bmp'"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ::aStretch[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRETCH '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aBorder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDER '
      ENDIF
      IF ::aClientEdge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aBuffer[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ::aDIBSection[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NODIBSECTION '
      ENDIF
      IF ::aNo3DColors[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aNoLoadTrans[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aFit[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NORESIZE '
      ENDIF
      IF ::aWhiteBack[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHITEBACKGROUND '
      ENDIF
      IF ::aImageSize[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESIZE '
      ENDIF
      IF ! Empty( ::aExclude[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EXCLUDEAREA ' + AllTrim( ::aExclude[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'IPADDRESS'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' IPADDRESS ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::avalue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( ::avalue[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::anotabstop[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'LABEL'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' LABEL ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSIZE '
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      ENDIF
      IF ! Empty( ::aValue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( ::avalue[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aHelpID[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aCenterAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CENTERALIGN '
      ENDIF
      IF ::aRightAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF ::aClientEdge[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CLIENTEDGE '
      ENDIF
      IF ::aBorder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDER '
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! Empty( ::aInputMask[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( ::aInputMask[j] )
      ENDIF
      IF ::aNoVScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VSCROLL '
      ENDIF
      IF ::aNoHScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HSCROLL '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aWrap[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOWORDWRAP '
      ENDIF
      IF ::aNoPrefix[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOPREFIX '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'LIST'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' LISTBOX ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aItems[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMS ' + AllTrim( ::aItems[j] )
      ENDIF
      IF ::avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::avaluen[j] ) )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( ::aOnDblClick[j] )
      ENDIF
      IF ::aMultiSelect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MULTISELECT '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
/*
   TODO: Add SPLITBOX support
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
*/
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aSort[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SORT '
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aOnEnter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aOnEnter[j] )
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
         IF ::aFit[j]
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIT '
         ENDIF
      ENDIF
      IF ::aTextHeight[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TEXTHEIGHT ' + LTrim( Str( ::aTextHeight[j] ) )
      ENDIF
      IF ::anovscroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'ANIMATE'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' ANIMATEBOX ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aFile[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FILE ' + StrToStr( ::aFile[j] )
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOPLAY '
      ENDIF
      IF ::aCenter[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CENTER '
      ENDIF
      IF ::aTransparent[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'PLAYER'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' PLAYER ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FILE ' + StrToStr( ::aFile[j] )
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aNoAutoSizeWindow[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOAUTOSIZEWINDOW '
      ENDIF
      IF ::aNoAutoSizeMovie[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOAUTOSIZEMOVIE '
      ENDIF
      IF ::aNoErrorDlg[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOERRORDLG '
      ENDIF
      IF ::aNoMenu[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOMENU '
      ENDIF
      IF ::aNoOpen[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOOPEN '
      ENDIF
      IF ::aNoPlayBar[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOPLAYBAR '
      ENDIF
      IF ::aShowAll[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWALL '
      ENDIF
      IF ::aShowMode[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWMODE '
      ENDIF
      IF ::aShowName[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWNAME '
      ENDIF
      IF ::aShowPosition[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SHOWPOSITION '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'MONTHCALENDAR'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' MONTHCALENDAR ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::avalue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + AllTrim( ::avalue[j] )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoToday[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTODAY '
      ENDIF
      IF ::aNoTodayCircle[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTODAYCIRCLE '
      ENDIF
      IF ::aWeekNumbers[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WEEKNUMBERS '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aTitleFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TITLEFONTCOLOR ' + ::aTitleFontColor[j]
      ENDIF
      IF ::aTitleBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TITLEBACKCOLOR ' + ::aTitleBackColor[j]
      ENDIF
      IF ::aTrailingFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRAILINGFONTCOLOR ' + ::aTrailingFontColor[j]
      ENDIF
      IF ::aBackgroundColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKGROUNDCOLOR ' + ::aBackgroundColor[j]
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'PICBUTT'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' BUTTON ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "PICTURE " + StrToStr( ::aPicture[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "PICTURE " + "'" + "'"
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + "MsgInfo( 'Button Pressed' )"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aFlat[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FLAT '
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! Empty( ::aBuffer[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ::aNoLoadTrans[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aForceScale[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCESCALE '
      ENDIF
      IF ::aNo3DColors[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aFit[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOFIT '
      ENDIF
      IF ::aDIBSection[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DIBSECTION '
      ENDIF
      IF ! Empty( ::aOnMouseMove[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON MOUSEMOVE ' + AllTrim( ::aOnMouseMove[j] )
      ENDIF
      IF ::aThemed[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ! Empty( ::aImageMargin[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGEMARGIN ' + AllTrim( ::aImageMargin[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         // Must end with a space
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + Upper( AllTrim( ::aJustify[j] ) ) + " "
      ENDIF
      IF ::aCancel[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CANCEL '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'PICCHECKBUTT'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' CHECKBUTTON ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aPicture[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + StrToStr( ::aPicture[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PICTURE ' + "'" + "'"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ::avaluel[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .T.'
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE .F.'
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! Empty( ::aBuffer[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUFFER ' + AllTrim( ::aBuffer[j] )
      ENDIF
      IF ! Empty( ::aHBitmap[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HBITMAP ' + AllTrim( ::aHBitmap[j] )
      ENDIF
      IF ::aNoLoadTrans[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLOADTRANSPARENT '
      ENDIF
      IF ::aForceScale[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORCESCALE '
      ENDIF
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ::aNo3DColors[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NO3DCOLORS '
      ENDIF
      IF ::aFit[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOFIT '
      ENDIF
      IF ::aDIBSection[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DIBSECTION '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aThemed[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ! Empty( ::aImageMargin[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGEMARGIN ' + AllTrim( ::aImageMargin[j] )
      ENDIF
      IF ! Empty( ::aOnMouseMove[j] )
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON MOUSEMOVE ' + AllTrim( ::aOnMouseMove[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         // Must end with a space
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + Upper( AllTrim( ::aJustify[j] ) ) + " "
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'PROGRESSBAR'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' PROGRESSBAR ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aRange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( ::aRange[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aVertical[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VERTICAL '
      ENDIF
      IF ::aSmooth[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SMOOTH '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORECOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aMarquee[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MARQUEE ' + LTrim( Str( ::aMarquee[j] ) )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'RADIOGROUP'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' RADIOGROUP ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aItems[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "OPTIONS " + AllTrim( ::aItems[j] )
      ENDIF
      IF ::avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::avaluen[j] ) )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      // Do no include HEIGHT
      IF ::aSpacing[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + "SPACING " + LTrim( Str( ::aSpacing[j] ) )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ::aTransparent[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TRANSPARENT '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSIZE '
      ENDIF
      IF ::aVertical[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VERTICAL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aThemed[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'THEMED '
      ENDIF
      IF ! Empty( ::aBackground[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKGROUND ' + AllTrim( ::aBackground[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'RICHEDIT'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' RICHEDITBOX ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ! Empty( ::avalue[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( ::avalue[j] )
      ENDIF
      IF ::aReadOnly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aMaxLength[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MAXLENGTH ' + LTrim( Str( ::aMaxLength[j] ) )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! Empty( ::aOnSelChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON SELCHANGE ' + AllTrim( ::aOnSelChange[j] )
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::aNoHideSel[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHIDESEL '
      ENDIF
      IF ::aFocusedPos[j] <> -4            // default value, see DATA nOnFocusPos in h_textbox.prg
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSEDPOS ' + LTrim( Str( ::aFocusedPos[j] ) )
      ENDIF
      IF ::aNoVScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF ::aNoHScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHSCROLL '
      ENDIF
      IF ! Empty( ::aFile[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FILE ' + StrToStr( ::aFile[j] )
      ENDIF
      IF ::aPlainText[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PLAINTEXT '
      ENDIF
      IF ::aFileType[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FILETYPE ' + LTrim( Str( ::aFileType[j] ) )
      ENDIF
      IF ! Empty( ::aOnVScroll[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON VSCROLL ' + AllTrim( ::aOnVScroll[j] )
      ENDIF
      IF ! Empty( ::aOnHScroll[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HSCROLL ' + AllTrim( ::aOnHScroll[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'SLIDER'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' SLIDER ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aRange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( ::aRange[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE 1, 100'
      ENDIF
      IF ::avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::avaluen[j] ) )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ::aVertical[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VERTICAL '
      ENDIF
      IF ::aNoTicks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTICKS '
      ENDIF
      IF ::aBoth[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOTH '
      ENDIF
      IF ::aTop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOP '
      ENDIF
      IF ::aLeft[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LEFT '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'SPINNER'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' SPINNER ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ! Empty( ::aRange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RANGE ' + AllTrim( ::aRange[j] )
      ENDIF
      IF ::avaluen[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::avaluen[j] ) )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aWrap[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WRAP '
      ENDIF
      IF ::aReadOnly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF ::aIncrement[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INCREMENT ' + LTrim( Str( ::aIncrement[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aRTL[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ::aBorder[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBORDER '
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'TEXT'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TEXTBOX ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELD ' + AllTrim( ::aField[j] )
      ENDIF
      IF ::aValue[j] == NIL
         cValue := ''
      ELSE
         cValue := AllTrim( ::aValue[j] )
      ENDIF
      IF ! Empty( cValue )
         IF ::aNumeric[j]
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + cValue
         ELSE
            IF ::aDate[j]
               Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + cValue
            ELSE
               Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + StrToStr( cValue )
            ENDIF
         ENDIF
      ENDIF
      IF ::aReadOnly[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY '
      ENDIF
      IF ::aPassWord[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PASSWORD '
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ::aNumeric[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NUMERIC '
         IF ! Empty( ::aInputMask[j] )
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + StrToStr( ::aInputMask[j] )
         ENDIF
      ELSE
         IF ! Empty( ::aInputMask[j] )
            Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + StrToStr( ::aInputMask[j] )
         ENDIF
      ENDIF
      IF ! Empty( ::aFields[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FORMAT ' + StrToStr( ::aFields[j] )
      ENDIF
      IF ::aDate[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DATE '
      ENDIF
      IF ::aMaxLength[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'MAXLENGTH ' + LTrim( Str( ::aMaxLength[j] ) )
      ENDIF
      IF ::aUpperCase[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPPERCASE '
      ENDIF
      IF ::aLowerCase[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LOWERCASE '
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ::aRightAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RIGHTALIGN '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ::aFocusedPos[j] <> -2            // default value, see DATA nOnFocusPos in h_textbox.prg
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSEDPOS ' + LTrim( Str( ::aFocusedPos[j] ) )
      ENDIF
      IF ! Empty( ::avalid[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( ::avalid[j] )
      ENDIF
      IF ! Empty( ::aWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( ::aWhen[j] )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ! Empty( ::aAction2[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION2 ' + AllTrim( ::aAction2[j] )
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aCenterAlign[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CENTERALIGN '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aBorder[j]
        Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBORDER '
      ENDIF
      IF ::aAutoPlay[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AUTOSKIP '
      ENDIF
      IF ! Empty( ::aOnTextFilled[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON TEXTFILLED ' + AllTrim( ::aOnTextFilled[j] )
      ENDIF
      IF ::aDefaultYear[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DEFAULTYEAR ' + LTrim( Str( ::aDefaultYear[j] ) )
      ENDIF
      IF ::aButtonWidth[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BUTTONWIDTH ' + LTrim( Str( ::aButtonWidth[j] ) )
      ENDIF
      IF ::aInsertType[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INSERTTYPE ' + LTrim( Str( ::aInsertType[j] ) )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'TIMER'
      // Do not delete next 3 lines, they are needed to load the control properly.
      Output += Space( nSpacing ) + '*****@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TIMER ' + AllTrim( ::aName[j] ) + ' ;' + CRLF
      Output += Space( nSpacing ) + '*****' + Space( nSpacing ) + 'ROW ' + LTrim( Str( nRow ) ) + ' ;' + CRLF
      Output += Space( nSpacing ) + '*****' + Space( nSpacing ) + 'COL ' + LTrim( Str( nCol ) ) + CRLF
      Output += Space( nSpacing * ( nLevel + 1 ) ) + 'DEFINE TIMER ' + AllTrim( ::aName[j] )
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      IF ::avaluen[j] > 999
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INTERVAL ' + LTrim( Str( ::avaluen[j] ) )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INTERVAL ' + LTrim( Str( 1000 ) )
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + '_dummy()'
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'TREE'
      // Do not delete next line, it's needed to load the fmg properly.
      Output += Space( nSpacing ) + '*****@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' TREE ' + AllTrim( ::aName[j] ) + ' ;' + CRLF
      Output += Space( nSpacing * nLevel ) + 'DEFINE TREE ' + AllTrim( ::aName[j] )
      IF ! Empty( ::aCObj[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AT ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( ::aOnDblClick[j] )
      ENDIF
      IF ! Empty( ::aNodeImages[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NODEIMAGES ' + AllTrim( ::aNodeImages[j] )
      ENDIF
      IF ! Empty( ::aItemImages[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMIMAGES ' + AllTrim( ::aItemImages[j] )
      ENDIF
      IF ::aNoRootButton[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOROOTBUTTON '
      ENDIF
      IF ::aItemIDs[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITEMIDS '
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aFull[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FULLROWSELECT '
      ENDIF
      IF ::aValue[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValue[j] ) )
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! Empty( ::aOnEnter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aOnEnter[j] )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aNoTabStop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! Empty( AllTrim( ::aSelColor[j] ) ) .AND. UpperNIL( ::aSelColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELCOLOR ' + AllTrim( ::aSelColor[j] )
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELBOLD '
      ENDIF
      IF ::aCheckBoxes[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'CHECKBOXES '
      ENDIF
      IF ::aEditLabels[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDITLABELS '
      ENDIF
      IF ::aNoHScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHSCROLL '
      ENDIF
      IF ::aNoVScroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOSCROLL '
      ENDIF
      IF ::aHotTrack[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HOTTRACKING '
      ENDIF
      IF ::aButtons[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOBUTTONS '
      ENDIF
      IF ::aDrag[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ENABLEDRAG '
      ENDIF
      IF ::aDrop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ENABLEDROP '
      ENDIF
      IF ! Empty( ::aTarget[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TARGET ' + AllTrim( ::aTarget[j] )
      ENDIF
      IF ::aSingleExpand[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SINGLEEXPAND '
      ENDIF
      IF ::aBorder[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BORDERLESS '
      ENDIF
      IF ! Empty( ::aOnLabelEdit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LABELEDIT ' + AllTrim( ::aOnLabelEdit[j] )
      ENDIF
      IF ! Empty( ::aValid[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( ::aValid[j] )
      ENDIF
      IF ! Empty( ::aOnCheckChg[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHECKCHANGE ' + AllTrim( ::aOnCheckChg[j] )
      ENDIF
      IF ::aIndent[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INDENT ' + LTrim( Str( ::aIndent[j] ) )
      ENDIF
      IF ! Empty( ::aOnDrop[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DROP ' + AllTrim( ::aOnDrop[j] )
      ENDIF
      IF ::aNoLines[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLINES '
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      Output += CRLF + CRLF
/*
   TODO: Add

   #xcommand DEFINE NODE <text> ;
      [ IMAGES <aImage> ] ;
      [ ID <id> ] ;
      [ <checked: CHECKED> ] ;
      [ <readonly: READONLY> ] ;
      [ <bold: BOLD> ] ;
      [ <disabled: DISABLED> ] ;
      [ <nodrag: NODRAG> ] ;
      [ <autoid: AUTOID> ] ;

   #xcommand TREEITEM <text> ;
      [ IMAGES <aImage> ] ;
      [ ID <id> ] ;
      [ <checked: CHECKED> ] ;
      [ <readonly: READONLY> ] ;
      [ <bold: BOLD> ] ;
      [ <disabled: DISABLED> ] ;
      [ <nodrag: NODRAG> ] ;
      [ <autoid: AUTOID> ] ;
*/
      Output += Space( nSpacing * nLevel ) + "END TREE " + CRLF + CRLF
   ENDIF

   IF ::aCtrlType[j] == 'XBROWSE'
      // Must end with a space
      Output += Space( nSpacing * nLevel ) + '@ ' + LTrim( Str( nRow ) ) + ', ' + LTrim( Str( nCol ) ) + ' XBROWSE ' + AllTrim( ::aName[j] ) + ' '
      IF ! Empty( ::aCObj[j ] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'OBJ ' + AllTrim( ::aCObj[j] )
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTH ' + LTrim( Str( nWidth ) )
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEIGHT ' + LTrim( Str( nHeight ) )
      IF ! Empty( ::aHeaders[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + AllTrim( ::aHeaders[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERS ' + "{ '', '' }"
      ENDIF
      IF ! Empty( ::aWidths[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + AllTrim( ::aWidths[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WIDTHS ' + "{ 90, 60 }"
      ENDIF
      Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WORKAREA ' + AllTrim( ::aWorkArea[j] )
      IF ! Empty( ::aFields[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELDS ' + AllTrim( ::aFields[j] )
      ELSE
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIELDS ' + "{ 'field1', 'field2' }"
      ENDIF
      IF ::aValueN[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALUE ' + LTrim( Str( ::aValueN[j] ) )
      ENDIF
      IF ! Empty( ::aFontName[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONT ' + StrToStr( ::aFontName[j] )
      ENDIF
      IF ::aFontSize[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SIZE ' + LTrim( Str( ::aFontSize[j] ) )
      ENDIF
      IF ! Empty( ::aToolTip[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'TOOLTIP ' + StrToStr( ::aToolTip[j] )
      ENDIF
      IF ! Empty( ::aInputMask[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPUTMASK ' + AllTrim( ::aInputMask[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicBackColor[j] ) ) .AND. UpperNIL( ::aDynamicBackColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBACKCOLOR ' + AllTrim( ::aDynamicBackColor[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aDynamicForeColor[j] ) ) .AND. UpperNIL( ::aDynamicForeColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICFORECOLOR ' + AllTrim( ::aDynamicForeColor[j] )
      ENDIF
      IF ! Empty( ::aColumnControls[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNCONTROLS ' + AllTrim( ::aColumnControls[j] )
      ENDIF
      IF ! Empty( ::aOnChange[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON CHANGE ' + AllTrim( ::aOnChange[j] )
      ENDIF
      IF ! Empty( ::aOnGotFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON GOTFOCUS ' + AllTrim( ::aOnGotFocus[j] )
      ENDIF
      IF ! Empty( ::aOnLostFocus[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON LOSTFOCUS ' + AllTrim( ::aOnLostFocus[j] )
      ENDIF
      IF ! Empty( ::aOnDblClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DBLCLICK ' + AllTrim( ::aOnDblClick[j] )
      ENDIF
      IF ! Empty( ::aOnHeadClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADCLICK ' + AllTrim( ::aOnHeadClick[j] )
      ENDIF
      IF ! Empty( ::aOnEditCell[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON EDITCELL ' + AllTrim( ::aOnEditCell[j] )
      ENDIF
      IF ! Empty( ::aOnAppend[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON APPEND ' + AllTrim( ::aOnAppend[j] )
      ENDIF
      IF ! Empty( ::aWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'WHEN ' + AllTrim( ::aWhen[j] )
      ENDIF
      IF ! Empty( ::avalid[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALID ' + AllTrim( ::avalid[j] )
      ENDIF
      IF ! Empty( ::aValidMess[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'VALIDMESSAGES ' + AllTrim( ::aValidMess[j] )
      ENDIF
      IF ! Empty( ::aReadOnlyB[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'READONLY ' + AllTrim( ::aReadOnlyB[j] )
      ENDIF
      IF ::aLock[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'LOCK '
      ENDIF
      IF ::aDelete[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DELETE '
      ENDIF
      IF ::aInPlace[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INPLACE '
      ENDIF
      IF ::aEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDIT '
      ENDIF
      IF ::anolines[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOLINES '
      ENDIF
      IF ! Empty( ::aImage[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGE ' + AllTrim( ::aImage[j] )
      ENDIF
      IF ! Empty( ::aJustify[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'JUSTIFY ' + AllTrim( ::aJustify[j] )
      ENDIF
      IF ! Empty( ::aonenter[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ENTER ' + AllTrim( ::aonenter[j] )
      ENDIF
      IF ::aHelpID[j] > 0
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HELPID ' + LTrim( Str( ::aHelpID[j] ) )
      ENDIF
      IF ::aAppend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'APPEND '
      ENDIF
      IF ::aBold[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BOLD '
      ENDIF
      IF ::aFontItalic[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ITALIC '
      ENDIF
      IF ::aFontUnderline[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UNDERLINE '
      ENDIF
      IF ::aFontStrikeout[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'STRIKEOUT '
      ENDIF
      IF ::aBackColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BACKCOLOR ' + ::aBackColor[j]
      ENDIF
      IF ::aFontColor[j] # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FONTCOLOR ' + ::aFontColor[j]
      ENDIF
      IF ! Empty( ::aAction[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ACTION ' + AllTrim( ::aAction[j] )
      ENDIF
      IF ::aBreak[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BREAK '
      ENDIF
      IF ::aRTL[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RTL '
      ENDIF
      IF ! ::aEnabled[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DISABLED '
      ENDIF
      IF ::anotabstop[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOTABSTOP '
      ENDIF
      IF ! ::aVisible[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'INVISIBLE '
      ENDIF
      IF ::aFull[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FULLMOVE '
      ENDIF
      IF ::aButtons[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'USEBUTTONS '
      ENDIF
      IF ::aNoHeaders[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOHEADERS '
      ENDIF
      IF ! Empty( ::aHeaderImages[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'HEADERIMAGES ' + AllTrim( ::aHeaderImages[j] )
      ENDIF
      IF ! Empty( ::aImagesAlign[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'IMAGESALIGN ' + AllTrim( ::aImagesAlign[j] )
      ENDIF
      IF ! Empty( AllTrim( ::aSelColor[j] ) ) .AND. UpperNIL( ::aSelColor[j] ) # 'NIL'
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SELECTEDCOLORS ' + AllTrim( ::aSelColor[j] )
      ENDIF
      IF ! Empty( ::aEditKeys[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EDITKEYS ' + AllTrim( ::aEditKeys[j] )
      ENDIF
      IF ::aDoubleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DOUBLEBUFFER '
      ENDIF
      IF ::aSingleBuffer[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SINGLEBUFFER '
      ENDIF
      IF ::aFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FOCUSRECT '
      ENDIF
      IF ::aNoFocusRect[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOFOCUSRECT '
      ENDIF
      IF ::aPLM[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'PAINTLEFTMARGIN '
      ENDIF
      IF ::aFixedCols[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCOLS '
      ENDIF
      IF ! Empty( ::aOnAbortEdit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON ABORTEDIT ' + AllTrim( ::aOnAbortEdit[j] )
      ENDIF
      IF ::aFixedWidths[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDWIDTHS '
      ENDIF
      IF ! Empty( ::aBeforeColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLMOVE ' + AllTrim( ::aBeforeColMove[j] )
      ENDIF
      IF ! Empty( ::aAfterColMove[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLMOVE ' + AllTrim( ::aAfterColMove[j] )
      ENDIF
      IF ! Empty( ::aBeforeColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFORECOLSIZE ' + AllTrim( ::aBeforeColSize[j] )
      ENDIF
      IF ! Empty( ::aAfterColSize[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'AFTERCOLSIZE ' + AllTrim( ::aAfterColSize[j] )
      ENDIF
      IF ! Empty( ::aBeforeAutoFit[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'BEFOREAUTOFIT ' + AllTrim( ::aBeforeAutoFit[j] )
      ENDIF
      IF ::aLikeExcel[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'EDITLIKEEXCEL '
      ENDIF
      IF ! Empty( ::aDeleteWhen[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEWHEN ' + AllTrim( ::aDeleteWhen[j] )
      ENDIF
      IF ! Empty( ::aDeleteMsg[j] )
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'DELETEMSG ' + AllTrim( ::aDeleteMsg[j] )
      ENDIF
      IF ! Empty( ::aOnDelete[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON DELETE ' + AllTrim( ::aOnDelete[j] )
      ENDIF
      IF ::aNoDelMsg[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'NODELETEMSG '
      ENDIF
      IF ::aFixedCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDCONTROLS '
      ENDIF
      IF ::aDynamicCtrls[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICCONTROLS '
      ENDIF
      IF ! Empty( ::aOnHeadRClick[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'ON HEADRCLICK ' + AllTrim( ::aOnHeadRClick[j] )
      ENDIF
      IF ::aExtDblClick[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'EXTDBLCLICK '
      ENDIF
      IF ::anovscroll[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOVSCROLL '
      ENDIF
      IF ! Empty( ::aReplaceField[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'REPLACEFIELD ' + AllTrim( ::aReplaceField[j] )
      ENDIF
      IF ! Empty( ::aSubClass[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'SUBCLASS ' + AllTrim( ::aSubClass[j] )
      ENDIF
      IF ::aRecCount[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'RECCOUNT '
      ENDIF
      IF ! Empty( ::aColumnInfo[j] )
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'COLUMNINFO ' + AllTrim( ::aColumnInfo[j] )
      ENDIF
      IF ::aDescend[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DESCENDING '
      ENDIF
      IF ::aFixBlocks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'FIXEDBLOCKS '
      ELSEIF ::aDynBlocks[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'DYNAMICBLOCKS '
      ENDIF
      IF ::aUpdateColors[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'UPDATECOLORS '
      ENDIF
      IF ::aShowNone[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NOSHOWEMPTYROW '
      ENDIF
      IF ::aNoModalEdit[j]
         Output += ' ;' + CRLF + Space( nSpacing * 2) + 'NOMODALEDIT '
      ENDIF
      IF ::aByCell[j]
         Output += ' ;' + CRLF + Space( nSpacing * ( nLevel + 1 ) ) + 'NAVIGATEBYCELL '
      ENDIF

      Output += CRLF + CRLF
   ENDIF

/*
   TODO: Add this controls

   ACTIVEX
   CHECKLIST
   HOTKEYBOX
   INTERNAL
   PICTURE
   PLAY WAVE
   PROGRESSMETER
   SCROLLBAR
   SPLITBOX
   TEXTARRAY
*/
RETURN Output

//------------------------------------------------------------------------------
METHOD Properties_Click() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oControl, cName, j, kp, cArray, cTitle, aLabels, aInitValues, cNameW
LOCAL aFormats, aResults, nStyle, uTemp, nRow, nCol, nWidth, nHeight, cItems

   IF ::nHandleP <= 0
      RETURN NIL
   ENDIF

   oControl := ::oDesignForm:aControls[::nHandleP]
   cName := Lower( oControl:Name )
   j := aScan( ::aControlW, { |c| Lower( c ) == cName } )
   IF j <= 0
      RETURN NIL
   ENDIF

   IF oControl:Type == 'TAB'
      ::TabProperties( j, oControl )
      IF IsValidArray( ::aCaption[j] )
         cArray := &( ::aCaption[j] )
         FOR kp := 1 TO Len( cArray )
            oControl:Value := kp
            oControl:Caption := cArray[kp]
         NEXT kp
         oControl:Visible := .F.
         oControl:Visible := .T.
         ::lFsave := .F.
         ::RefreshControlInspector()
      ENDIF
      RETURN NIL
   ENDIF

   cNameW := ::aName[j]

   IF ::aCtrlType[j] == 'FRAME'
     cTitle      := cNameW + " properties"
     aLabels     := { 'Caption',     'Opaque',     'Transparent',     'Name',     'Enabled',     'Visible',     'Obj',      'RTL',     'SubClass' }
     aInitValues := { ::acaption[j], ::aopaque[j], ::atransparent[j], ::aname[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aRTL[j], ::aSubClass[j] }
     aFormats    := { 30,           .F.,         .F.,              30,        .F.,          .F.,          31,        .F.,      250 }
     aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      IF ! Empty( aResults[1] )
         oControl:Caption := aResults[1]
      ENDIF
      ::acaption[j]          := aResults[01]
      ::aopaque[j]           := aResults[02]
      ::atransparent[j]      := aResults[03]
      ::aname[j]             := IIF( Empty( aResults[04] ), ::aName[j], aResults[04] )
      ::aenabled[j]          := aResults[05]
      ::avisible[j]          := aResults[06]
      ::acobj[j]             := aResults[07]
      ::aRTL[j]              := aResults[08]
      ::aSubClass[j]         := aResults[09]
   ENDIF

   IF ::aCtrlType[j] == 'TEXT'
      cTitle      := cNameW + " properties"
      aLabels     := { 'ToolTip',      'MaxLength',     'UpperCase',     'RightAlign',     'Value',     'Password',     'LowerCase',     'Numeric',     'InputMask',     'HelpID',     'Field',     'ReadOnly',     'Enabled',     'Visible',     'NoTabStop',     'Date',     'Name',     'Format',     'FocusedPos',     'Valid',     'When',     'Obj',      'Action',     'Action2',     'Image',     'CenterAlign',     'RTL',     'NoBorder',   'AutoSkip',     'DefaultYear',     'ButtonWidth',     'InsertType',     'SubClass' }
      aInitValues := { ::atooltip[j],  ::amaxlength[j], ::auppercase[j], ::arightalign[j], ::avalue[j], ::apassword[j], ::alowercase[j], ::anumeric[j], ::ainputmask[j], ::aHelpID[j], ::afield[j], ::areadonly[j], ::aenabled[j], ::avisible[j], ::anotabstop[j], ::adate[j], ::aname[j], ::afields[j], ::afocusedpos[j], ::avalid[j], ::awhen[j], ::acobj[j], ::aaction[j], ::aaction2[j], ::aimage[j], ::aCenterAlign[j], ::aRTL[j], ::aBorder[j], ::aAutoPlay[j], ::aDefaultYear[j], ::aButtonWidth[j], ::aInsertType[j], ::aSubClass[j] }
      aFormats    := { 120,            '999',           .F.,             .F.,              40,          .F.,            .F.,             .F.,           30,              '999',        250,         .F.,            .F.,           .F.,           .F.,             .F.,        30,         30,           '99',             250,         250,        31,         250,          250,           250,         .F.,               .F.,       .F.,          .F.,            '9999',           '9999',             '9',              250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aToolTip[j]          := aResults[01]
      oControl:ToolTip       := aResults[01]
      ::aMaxLength[j]        := IIF( ! Empty( aResults[09] ) .OR. aResults[16], 0, Max( aResults[02], 0 ) )
      ::aUpperCase[j]        := aResults[03]
      ::aRightAlign[j]       := aResults[04]
      ::aValue[j]            := aResults[05]
      ::aPassword[j]         := aResults[06]
      ::aLowerCase[j]        := aResults[07]
      ::aNumeric[j]          := aResults[08]
      ::aInputMask[j]        := aResults[09]
      ::aHelpID[j]           := aResults[10]
      ::aField[j]            := aResults[11]
      ::aReadOnly[j]         := aResults[12]
      ::aEnabled[j]          := aResults[13]
      ::aVisible[j]          := aResults[14]
      ::aNoTabStop[j]        := aResults[15]
      ::aDate[j]             := aResults[16]
      ::aName[j]             := IIF( Empty( aResults[17] ), ::aName[j], aResults[17] )
      ::aFields[j]           := aResults[18]           // FORMAT
      ::aFocusedPos[j]       := aResults[19]
      ::aValid[j]            := aResults[20]
      ::aWhen[j]             := aResults[21]
      ::aCObj[j]             := aResults[22]
      ::aAction[j]           := aResults[23]
      ::aAction2[j]          := aResults[24]
      ::aImage[j]            := aResults[25]
      ::aCenterAlign[j]      := aResults[26]
      ::aRTL[j]              := aResults[27]
      ::aBorder[j]           := aResults[28]
      ::aAutoPlay[j]         := aResults[29]
      ::aDefaultYear[j]      := aResults[30]
      ::aButtonWidth[j]      := aResults[31]
      ::aInsertType[j]       := aResults[32]
      ::aSubClass[j]         := aResults[33]
   ENDIF

   IF ::aCtrlType[j] == 'IPADDRESS'
      cTitle      := cNameW + " properties"
      aLabels     := { 'ToolTip',     'Value',     'HelpID',     'Enabled',     'Visible',     'NoTabStop',     'Name',     'Obj',      "RTL",     'SubClass' }
      aInitValues := { ::atooltip[j], ::avalue[j], ::aHelpID[j], ::aenabled[j], ::avisible[j], ::anotabstop[j], ::aname[j], ::acobj[j], ::aRTL[j], ::aSubClass[j] }
      aFormats    := { 120,           30,          '999',        .T.,           .T.,           .F.,             30,         31,         .F.,       250   }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aTooltip[j]          := aResults[01]
      oControl:tooltip       := aResults[01]
      ::avalue[j]            := aResults[02]
      oControl:value         := IIF( Empty( aResults[02] ), "   .   .   .   ", aResults[02] )
      ::aHelpID[j]           := aResults[03]
      ::aenabled[j]          := aResults[04]
      ::avisible[j]          := aResults[05]
      ::anotabstop[j]        := aResults[06]
      ::aName[j]             := IIF( Empty( aResults[07] ), ::aName[j], aResults[07] )
      ::acobj[j]             := aResults[08]
      ::aRTL[j]              := aResults[09]
      ::aSubClass[j]         := aResults[10]
   ENDIF

   IF ::aCtrlType[j] == 'HYPERLINK'
      cTitle      := cNameW + " properties"
      aLabels     := { 'ToolTip',     'Value',     'HelpID',     'Enabled',     'Visible',     'Address',     'HandCursor',     'Name',     'Obj',      'AutoSize',     'Border',     'ClientEdge',     'HScroll',       'VScroll',       'Transparent',     'RTL' }
      aInitValues := { ::atooltip[j], ::avalue[j], ::aHelpID[j], ::aenabled[j], ::avisible[j], ::aaddress[j], ::ahandcursor[j], ::aname[j], ::acobj[j], ::aAutoPlay[j], ::aBorder[j], ::aClientEdge[j], ::aNoHScroll[j], ::aNoVScroll[j], ::aTransparent[j], ::aRTL[j] }
      aFormats    := { 120,           30,          '999',        .T.,           .T.,           60,            .F.,              30,         31,         .F.,            .F.,          .F.,              .F.,             .F.,             .F.,               .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aToolTip[j]          := aResults[01]
      oControl:ToolTip       := aResults[01]
      ::aValue[j]            := IIF( Empty( aResults[2] ), ::aValue[j], aResults[2] )
      oControl:Value         := ::aValue[j]
      ::aHelpID[j]           := aResults[03]
      ::aEnabled[j]          := aResults[04]
      ::aVisible[j]          := aResults[05]
      ::aAddress[j]          := aResults[06]
      ::aHandCursor[j]       := aResults[07]
      ::aName[j]             := IIF( Empty( aResults[08] ), ::aName[j], aResults[08] )
      ::aCObj[j]             := aResults[09]
      ::aAutoPlay[j]         := aResults[10]
      ::aBorder[j]           := aResults[11]
      ::aClientEdge[j]       := aResults[12]
      ::aNoHScroll[j]        := aResults[13]
      ::aNoVScroll[j]        := aResults[14]
      ::aTransparent[j]      := aResults[15]
      ::aRTL[j]              := aResults[16]
   ENDIF

   IF ::aCtrlType[j] == 'TREE'
      cTitle      := cNameW + " properties"
      aLabels     := { 'ToolTip',     'Enabled',     'Visible',     'Name',     'NodeImages',     'ItemImages',     'NoRootButton',     'ItemIDs',     'HelpID',     'Obj',      'FullRowSelect',  'Value',     'RTL',     'Break',     'NoTabStop',     'SelColor',     'SelBold',     'CheckBoxes',     'EditLabels',     'NoHScroll',     'NoScroll',      'HotTracking',  'NoButtons',   'EnableDrag',  'EnableDrop',  'TargeT',     'SingleExpand',     'BorderLess',  'Valid',     'Indent',     'NoLines',    'SubClass' }
      aInitValues := { ::atooltip[j], ::aenabled[j], ::avisible[j], ::aname[j], ::Anodeimages[j], ::aitemimages[j], ::anorootbutton[j], ::aitemids[j], ::aHelpID[j], ::acobj[j], ::aFull[j],        ::aValue[j], ::aRTL[j], ::aBreak[j], ::aNoTabStop[j], ::aSelColor[j], ::aSelBold[j], ::aCheckBoxes[j], ::aEditLabels[j], ::aNoHScroll[j], ::aNoVScroll[j], ::aHotTrack[j], ::aButtons[j], ::aDrag[j],     ::aDrop[j],     ::aTarget[j], ::aSingleExpand[j], ::aBorder[j],   ::aValid[j], ::aIndent[j], ::aNoLines[j], ::aSubClass[j] }
      aFormats    := { 120,           .T.,           .T.,           60,         60,               60,               .F.,                .F.,           '999',        31,         .F.,              '999999',    .F.,       .F.,         .F.,             250,            .F.,           .F.,              .F.,              .F.,             .F.,             .F.,            .F.,           .F.,           .F.,           250,          .F.,                .F.,           250,         '999',        .F.,           250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::atooltip[j]          := aResults[01]
      oControl:tooltip       := aResults[01]
      ::aenabled[j]          := aResults[02]
      ::avisible[j]          := aResults[03]
      ::aName[j]             := IIF( Empty( aResults[04] ), ::aName[j], aResults[04] )
      ::anodeimages[j]       := aResults[05]
      ::aitemimages[j]       := aResults[06]
      ::anorootbutton[j]     := aResults[07]
      ::aitemids[j]          := aResults[08]
      ::aHelpID[j]           := aResults[09]
      ::acobj[j]             := aResults[10]
      ::aFull[j]             := aResults[11]
      ::aValue[j]            := aResults[12]
      ::aRTL[j]              := aResults[13]
      ::aBreak[j]            := aResults[14]
      ::aNoTabStop[j]        := aResults[15]
      ::aSelColor[j]         := aResults[16]
      ::aSelBold[j]          := aResults[17]
      ::aCheckBoxes[j]       := aResults[18]
      ::aEditLabels[j]       := aResults[19]
      ::aNoHScroll[j]        := aResults[20]
      ::aNoVScroll[j]        := aResults[21]
      ::aHotTrack[j]         := aResults[22]
      ::aButtons[j]          := aResults[23]
      ::aDrag[j]             := aResults[24]
      ::aDrop[j]             := aResults[25]
      ::aTarget[j]           := aResults[26]
      ::aSingleExpand[j]     := aResults[27]
      ::aBorder[j]           := aResults[28]
      ::aValid[j]            := aResults[29]
      ::aIndent[j]           := aResults[30]
      ::aNoLines[j]          := aResults[31]
      ::aSubClass[j]         := aResults[32]
   ENDIF

   IF ::aCtrlType[j] == 'EDIT'
      cTitle      := cNameW + " properties"
      aLabels     := { 'ToolTip',     'MaxLength',     'ReadOnly',     'Value',     'HelpID',     'Break',     'Field',     'Name',     'Enabled',     'Visible',     'NoTabStop',     'NoVScroll',     'NoHScroll',     'Obj',      'RTL',     'NoBorder',   'FocusedPos' }
      aInitValues := { ::atooltip[j], ::amaxlength[j], ::areadonly[j], ::avalue[j], ::aHelpID[j], ::abreak[j], ::afield[j], ::aname[j], ::aenabled[j], ::avisible[j], ::anotabstop[j], ::anovscroll[j], ::anohscroll[j], ::acobj[j], ::aRTL[j], ::aBorder[j], ::aFocusedPos[j] }
      aFormats    := { 120,           '999999',        .F.,            800,         '999',        .F.,         250,         30,         .F.,           .F.,           .F.,             .F.,             .F.,             31,         .F.,       .F.,          '99' }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::atooltip[j]          := aResults[01]
      oControl:tooltip       := aResults[01]
      ::amaxlength[j]        := Max( aResults[02],  0 )
      ::areadonly[j]         := aResults[03]
      oControl:value         := aResults[04]
      ::avalue[j]            := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::abreak[j]            := aResults[06]
      ::afield[j]            := aResults[07]
      ::aName[j]             := IIF( Empty( aResults[08] ), ::aName[j], aResults[08] )
      ::aenabled[j]          := aResults[09]
      ::avisible[j]          := aResults[10]
      ::anotabstop[j]        := aResults[11]
      ::anovscroll[j]        := aResults[12]
      ::anohscroll[j]        := aResults[13]
      ::acobj[j]             := aResults[14]
      ::aRTL[j]              := aResults[15]
      ::aBorder[j]           := aResults[16]
      ::aFocusedPos[j]       := aResults[17]
   ENDIF

   IF ::aCtrlType[j] == 'RICHEDIT'
      cTitle      := cNameW + " properties"
      aLabels     := { 'ToolTip',     'MaxLength',     'ReadOnly',     'Value',     'HelpID',     'Break',     'Field',     'Name',     'Enabled',     'Visible',     'NoTabStop',     'Obj',      'NoHideSel',     'PlainText',      'FileType',     'RTL',     'FocusedPos',     'NoVScroll',     'NoHScroll',     'File',     'SubClass' }
      aInitValues := { ::atooltip[j], ::amaxlength[j], ::areadonly[j], ::avalue[j], ::aHelpID[j], ::abreak[j], ::afield[j], ::aname[j], ::aenabled[j], ::avisible[j], ::anotabstop[j], ::acobj[j], ::aNoHideSel[j], ::aPlainText[j],   ::aFileType[j], ::aRTL[j], ::aFocusedPos[j], ::aNoVScroll[j], ::aNoHScroll[j], ::aFile[j], ::aSubClass[j] }
      aFormats    := { 120,           '999999',        .F.,            800,         '999',        .F.,         250,         30,         .F.,           .F.,           .F.,             31,         .F.,             .F.,              '9',            .F.,       '99',             .F.,             .F.,             250,        250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aToolTip[j]          := aResults[01]
      oControl:tooltip       := aResults[01]
      ::aMaxLength[j]        := Max( aResults[02], 0 )
      ::aReadonly[j]         := aResults[03]
      ::aValue[j]            := IIF( Empty( aResults[04] ), "", aResults[04] )
      oControl:Value         := ::aValue[j]
      ::aHelpID[j]           := aResults[05]
      ::aBreak[j]            := aResults[06]
      ::aField[j]            := aResults[07]
      ::aName[j]             := IIF( Empty( aResults[08] ), ::aName[j], aResults[08] )
      ::aEnabled[j]          := aResults[09]
      ::aVisible[j]          := aResults[10]
      ::aNotabStop[j]        := aResults[11]
      ::aCObj[j]             := aResults[12]
      ::aNoHideSel[j]        := aResults[13]
      ::aPlainText[j]        := aResults[14]
      ::aFileType[j]         := aResults[15]
      ::aRTL[j]              := aResults[16]
      ::aFocusedPos[j]       := aResults[17]
      ::aNoVScroll[j]        := aResults[18]
      ::aNoHScroll[j]        := aResults[19]
      ::aFile[j]             := aResults[20]
      ::aSubClass[j]         := aResults[21]
   ENDIF

   IF ::aCtrlType[j] == 'GRID'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Headers',     'Widths',     'Items',     'Value',     'ToolTip',     'MultiSelect',     'NoLines',     'Image',     'HelpID',     'Break',     'Justify',     'Name',     'Enabled',     'Visible',     "DynamicBackColor",     "DynamicForeColor",     "ColumnControls",     "Valid",     "ValidMessages",  "When",     "ReadOnly",      "InPlace",     "InputMask",     "Edit",     'Obj',       'Virtual',     'ItemCount',     'NoHeaders',     'HeaderImages',     'ImagesAlign',     'NavigateByCell',  'SelectedColor',  'EditKeys',     'DoubleBuffer',     'SingleBuffer',     "FocusedRect",   'NoFocusedRect',   'PaintLeftMargin',  'FixedCols',     'FixedWidths',     'BeforeColMove',     'AfterColMove',     'BeforeColSize',     'AfterColSize',     'BeforeAutoFit',     'LikeExcel',     'DeleteWhen',     'DeleteMsg',     'NoDelMsg',     'NoModalExit',     'FixedControls',  'DynamicControls',  'NoClickOnCheckBox',  'NoRClickOnCheckbox',  'ExtDblClick',      'SubClass'}
      aInitValues := { ::aheaders[j], ::awidths[j], ::aitems[j], ::aValueN[j], ::atooltip[j], ::amultiselect[j], ::anolines[j], ::aimage[j], ::aHelpID[j], ::abreak[j], ::ajustify[j], ::aname[j], ::aenabled[j], ::avisible[j], ::adynamicbackcolor[j], ::adynamicforecolor[j], ::acolumncontrols[j], ::avalid[j], ::avalidmess[j],    ::awhen[j], ::areadonlyb[j], ::ainplace[j], ::ainputmask[j], ::aedit[j], ::acobj[j], ::aVirtual[j], ::aItemCount[j], ::aNoHeaders[j], ::aHeaderImages[j], ::aImagesAlign[j], ::aByCell[j],       ::aSelColor[j],    ::aEditKeys[j], ::aDoubleBuffer[j], ::aSingleBuffer[j], ::aFocusRect[j], ::aNoFocusRect[j], ::aPLM[j],           ::aFixedCols[j], ::aFixedWidths[j], ::aBeforeColMove[j], ::aAfterColMove[j], ::aBeforeColSize[j], ::aAfterColSize[j], ::aBeforeAutoFit[j], ::aLikeExcel[j], ::aDeleteWhen[j], ::aDeleteMsg[j], ::aNoDelMsg[j], ::aNoModalEdit[j], ::aFixedCtrls[j], ::aDynamicCtrls[j], ::aNoClickOnCheck[j], ::aNoRClickOnCheck[j], ::aExtDblClick[j], ::aSubClass[j] }
      aFormats    := { 800,           800,          800,         "999999",     250,           .F.,               .F.,           60,          '999',        .F.,         350,           30,         .F.,           .F.,           350,                    350,                    800,                  800,         800,               800,        800,             .T.,           800,             .T.,        31,         .F.,           '9999',          .F.,             250,                250,               .F.,               250,              250,            .F.,                .F.,                .F.,             .F.,               .F.,                .F.,             .F.,               250,                 250,                250,                 250,                250,                 .F.,             250,              250,             250,            .F.,               .F.,              .F.,                .F.,                  .F.,                   .F.,               .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aheaders[j]          := aResults[01]
      ::awidths[j]           := aResults[02]
      ::aitems[j]            := aResults[03]
      ::aValueN[j]           := aResults[04]
      ::atooltip[j]          := aResults[05]
      ::amultiselect[j]      := aResults[06]
      ::anolines[j]          := aResults[07]
      ::aimage[j]            := aResults[08]
      ::aHelpID[j]           := aResults[09]
      ::aBreak[j]            := aResults[10]
      ::aJustify[j]          := IIF( Empty( aResults[11] ), ::aJustify[j], aResults[11] )
      ::aName[j]             := IIF( Empty( aResults[12] ), ::aName[j], aResults[12] )
      ::aenabled[j]          := aResults[13]
      ::avisible[j]          := aResults[14]
      ::adynamicbackcolor[j] := aResults[15]
      ::adynamicforecolor[j] := aResults[16]
      ::acolumncontrols[j]   := aResults[17]
      ::avalid[j]            := aResults[18]
      ::avalidmess[j]        := aResults[19]
      ::awhen[j]             := aResults[20]
      ::areadonlyb[j]        := aResults[21]
      ::ainplace[j]          := aResults[22]
      ::ainputmask[j]        := aResults[23]
      ::aedit[j]             := aResults[24]
      ::acobj[j]             := aResults[25]
      ::aVirtual[j]          := aResults[26]
      ::aItemCount[j]        := aResults[27]
      ::aNoHeaders[j]        := aResults[28]
      ::aHeaderImages[j]     := aResults[29]
      ::aImagesAlign[j]      := aResults[30]
      ::aByCell[j]           := aResults[31]
      ::aSelColor[j]         := aResults[32]
      ::aEditKeys[j]         := aResults[33]
      ::aDoubleBuffer[j]     := aResults[34]
      ::aSingleBuffer[j]     := aResults[35]
      ::aFocusRect[j]        := aResults[36]
      ::aNoFocusRect[j]      := aResults[37]
      ::aPLM[j]              := aResults[38]
      ::aFixedCols[j]        := aResults[39]
      ::aFixedWidths[j]      := aResults[40]
      ::aBeforeColMove[j]    := aResults[41]
      ::aAfterColMove[j]     := aResults[42]
      ::aBeforeColSize[j]    := aResults[43]
      ::aAfterColSize[j]     := aResults[44]
      ::aBeforeAutoFit[j]    := aResults[45]
      ::aLikeExcel[j]        := aResults[46]
      ::aDeleteWhen[j]       := aResults[47]
      ::aDeleteMsg[j]        := aResults[48]
      ::aNoDelMsg[j]         := aResults[49]
      ::aNoModalEdit[j]      := aResults[50]
      ::aFixedCtrls[j]       := aResults[51]
      ::aDynamicCtrls[j]     := aResults[52]
      ::aNoClickOnCheck[j]   := aResults[53]
      ::aNoRClickOnCheck[j]  := aResults[54]
      ::aExtDblClick[j]      := aResults[55]
      ::aSubClass[j]         := aResults[56]
   ENDIF

   IF ::aCtrlType[j] == 'LABEL'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Value',     'HelpID',     'Transparent',     'CenterAlign',     'RightAlign',     'ToolTip',     'Name',     'AutoSize',     "Enabled",     "Visible",     "ClientEdge",     "Border",    'Obj',      "InputMask",      'HScroll',       'VScroll',       'RTL',     'NoWrap',   'NoPrefix',     'SubClass' }
      aInitValues := { ::avalue[j], ::aHelpID[j], ::atransparent[j], ::acenteralign[j], ::arightalign[j], ::atooltip[j], ::aname[j], ::aautoplay[j], ::aenabled[j], ::avisible[j], ::aclientedge[j], ::aborder[j], ::acobj[j], ::ainputmask[j], ::aNoHScroll[j], ::aNoVScroll[j], ::aRTL[j], ::aWrap[j], ::aNoPrefix[j], ::aSubClass[j] }
      aFormats    := { 300,         '999',        .F.,               .F.,               .F.,              120,           30,         .F.,            .F.,           .F.,           .F.,              .F.,          31,         800,             .F.,             .F.,             .F.,       .F.,        .F.,            250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aValue[j]            := aResults[01]
      oControl:Value         := IIF( Empty( aResults[01] ), cName, aResults[01] )
      ::aHelpID[j]           := aResults[02]
      ::aTransparent[j]      := aResults[03]
      ::aCenterAlign[j]      := aResults[04]
      ::aRightAlign[j]       := aResults[05]
      oControl:Align         := IIF( aResults[04], SS_CENTER, IIF( aResults[05], SS_RIGHT, SS_LEFT ) )
      ::aToolTip[j]          := aResults[06]
      ::aName[j]             := IIF( Empty( aResults[07] ), ::aName[j], aResults[07] )
      ::aAutoPlay[j]         := aResults[08]
      ::aEnabled[j]          := aResults[09]
      ::aVisible[j]          := aResults[10]
      ::aClientEdge[j]       := aResults[11]
      ::aBorder[j]           := aResults[12]
      ::aCObj[j]             := aResults[13]
      ::aInputMask[j]        := aResults[14]
      ::aNoHScroll[j]        := aResults[15]
      ::aNoVScroll[j]        := aResults[16]
      ::aRTL[j]              := aResults[17]
      ::aWrap[j]             := aResults[18]
      ::aNoPrefix[j]         := aResults[19]
      ::aSubClass[j]         := aResults[20]
   ENDIF

   IF ::aCtrlType[j] == 'PROGRESSBAR'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Range',     'ToolTip',     'Vertical',     'Smooth',     'HelpID',     'Name',     'Enabled',     'Visible',     'Obj',      'Value',     'RTL',      'Marquee' }
      aInitValues := { ::arange[j], ::atooltip[j], ::avertical[j], ::asmooth[j], ::aHelpID[j], ::aname[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aValueN[j], ::aRTL[j],   ::aMarquee[j] }
      aFormats    := { 20,          120,           .F.,            .F.,          '999',        30,         .F.,           .F.,           31,         '9999',       .F.,        '9999' }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aRange[j]            := aResults[01]
      ::aToolTip[j]          := aResults[02]
      oControl:ToolTip       := aResults[02]
      ::aVertical[j]         := aResults[03]
      ::aSmooth[j]           := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::aName[j]             := IIF( Empty( aResults[06] ), ::aName[j], aResults[06] )
      oControl:Value         := ::aName[j]
      ::aEnabled[j]          := aResults[07]
      ::aVisible[j]          := aResults[08]
      ::aCObj[j]             := aResults[09]
      ::aValueN[j]           := aResults[10]
      ::aRTL[j]              := aResults[11]
      ::aMarquee[j]          := aResults[12]
   ENDIF

   IF ::aCtrlType[j] == 'SLIDER'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Range',     'Value ',     'ToolTip',     'Vertical',     'Both',     'Top',     'Left',     'HelpID',     'Name',     'Enabled',     'Visible',     'Obj',      'NoTicks',     'NoTabStop',     'RTL',     'SubClass' }
      aInitValues := { ::arange[j], ::avaluen[j], ::atooltip[j], ::avertical[j], ::aboth[j], ::atop[j], ::aleft[j], ::aHelpID[j], ::aname[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::anoticks[j], ::aNoTabStop[j], ::aRTL[j], ::aSubClass[j] }
      aFormats    := { 20,          '999',        120,           .F.,            .F.,        .F.,       .F.,        '999',        30,         .F.,           .F.,           31,         .F.,           .F.,             .F.,       250  }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aRange[j]            := aResults[01]
      ::aValueN[j]           := aResults[02]
      ::aToolTip[j]          := aResults[03]
      oControl:ToolTip       := aResults[03]
      ::aVertical[j]         := aResults[04]
      ::aBoth[j]             := aResults[05]
      ::aTop[j]              := aResults[06]
      ::aLeft[j]             := aResults[07]
      ::aHelpID[j]           := aResults[08]
      ::aName[j]             := IIF( Empty( aResults[09] ), ::aName[j], aResults[09] )
      ::aEnabled[j]          := aResults[10]
      ::aVisible[j]          := aResults[11]
      ::aCObj[j]             := aResults[12]
      ::aNoTicks[j]          := aResults[13]
      ::aNoTabStop[j]        := aResults[14]
      ::aRTL[j]              := aResults[15]
      ::aSubClass[j]         := aResults[16]
      nStyle := WindowStyleFlag( oControl:hWnd,  TBS_VERT )
      IF ( nStyle == TBS_HORZ .AND. ::aVertical[j] ) .OR. ( nStyle == TBS_VERT .AND. ! ::aVertical[j] )
          WindowStyleFlag( oControl:hWnd,  TBS_VERT,  TBS_VERT - nStyle )
          uTemp := oControl:Width
          oControl:Width  := oControl:Height
          oControl:Height := uTemp
      ENDIF
//         Dibuja( cNameW )
   ENDIF

   IF ::aCtrlType[j] == 'SPINNER'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Range',     'Value ',     'ToolTip',     'HelpID',     'NoTabStop',     'Wrap',     'ReadOnly',     'Increment',     'Name',     'Enabled',     'Visible',     'Obj',      'RTL',     'NoBorder' }
      aInitValues := { ::arange[j], ::avaluen[j], ::atooltip[j], ::aHelpID[j], ::anotabstop[j], ::awrap[j], ::areadonly[j], ::aincrement[j], ::aname[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aRTL[j], ::aBorder[j] }
      aFormats    := { 30,          '99999',      120,           '999',        .F.,             .F.,        .F.,            '999999',        30,         .F.,           .F.,           31,         .F.,       .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::arange[j]            := aResults[01]
      ::avaluen[j]           := aResults[02]
      ::atooltip[j]          := aResults[03]
      oControl:tooltip       := aResults[03]
      ::aHelpID[j]           := aResults[04]
      ::anotabstop[j]        := aResults[05]
      ::awrap[j]             := aResults[06]
      ::areadonly[j]         := aResults[07]
      ::aincrement[j]        := aResults[08]
      ::aName[j]             := IIF( Empty( aResults[09] ), ::aName[j], aResults[09] )
      ::aenabled[j]          := aResults[10]
      ::avisible[j]          := aResults[11]
      ::acobj[j]             := aResults[12]
      ::aRTL[j]              := aResults[13]
      ::aBorder[j]           := aResults[14]
   ENDIF

   IF ::aCtrlType[j] == 'BUTTON'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Caption',     'ToolTip',     'HelpID',     'NoTabStop',     'Enabled',     'Visible',     'Name',     'Flat',     'Picture',     "Alignment",   'Obj',      "RTL",     "NoPrefix",     "NoLoadTransp.",   "ForceScale",     "Cancel",     "MultiLine",     "Themed",     "No3DColors",     "AutoFit",  "DIB Section",    "Buffer",     "HBitmap",     "ImageMargin",     'SubClass' }
      aInitValues := { ::acaption[j], ::atooltip[j], ::aHelpID[j], ::anotabstop[j], ::aenabled[j], ::avisible[j], ::aname[j], ::aflat[j], ::aPicture[j], ::Ajustify[j], ::acobj[j], ::aRTL[j], ::aNoPrefix[j], ::aNoLoadTrans[j], ::aForceScale[j], ::aCancel[j], ::aMultiLine[j], ::aThemed[j], ::aNo3DColors[j], ::aFit[j],   ::aDIBSection[j], ::aBuffer[j], ::aHBitmap[j], ::aImageMargin[j], ::aSubClass[j] }
      aFormats    := { 300,           120,           '999',        .F.,             .T.,           .T.,           30,         .T.,        40,            20,            31,         .F.,       .F.,            .F.,               .F.,              .F.,          .F.,             .F.,          .F.,              .F.,        .F.,              300,          300,           300,               300 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::acaption[j]          := aResults[1]
      oControl:Caption       := IIF( Empty( aResults[1] ), cName, aResults[1] )
      ::atooltip[j]          := aResults[2]
      oControl:ToolTip       := aResults[2]
      ::aHelpID[j]           := aResults[3]
      ::anotabstop[j]        := aResults[4]
      ::aenabled[j]          := aResults[5]
      ::avisible[j]          := aResults[6]
      ::aname[j]             := IIF( Empty( aResults[7] ), ::aname[j], aResults[7] )
      ::aflat[j]             := aResults[8]
      ::apicture[j]          := aResults[9]
      ::ajustify[j]          := aResults[10]
      ::acobj[j]             := aResults[11]
      ::aRTL[j]              := aResults[12]
      ::aNoPrefix[j]         := aResults[13]
      ::aNoLoadTrans[j]      := aResults[14]
      ::aForceScale[j]       := aResults[15]
      ::aCancel[j]           := aResults[16]
      ::aMultiLine[j]        := aResults[17]
      ::aThemed[j]           := aResults[18]
      ::aNo3DColors[j]       := aResults[19]
      ::aFit[j]              := aResults[20]
      ::aDIBSection[j]       := aResults[21]
      ::aBuffer[j]           := aResults[22]
      ::aHBitmap[j]          := aResults[23]
      ::aImageMargin[j]      := aResults[24]
      ::aSubClass[j]         := aResults[25]
   ENDIF

   IF ::aCtrlType[j] == 'CHECKBOX'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Value',                                                           'Caption',     'ToolTip',     'HelpID',     'Field',     'Transparent',     'Enabled',     'Visible',     'Name',     "NoTabStop",     'Obj',      'AutoSize',     "RTL",     "ThreeState",  "Themed",     "LeftAlign" }
      aInitValues := { IIF( ::aValue[j] == '.T.', 1, IIF( ::aValue[j] == '.F.', 2, 3 ) ), ::acaption[j], ::atooltip[j], ::aHelpID[j], ::afield[j], ::atransparent[j], ::aenabled[j], ::avisible[j], ::aname[j], ::anotabstop[j], ::acobj[j], ::aautoplay[j], ::aRTL[j], ::a3State[j],  ::aThemed[j], ::aLeft[j] }
      aFormats    := { { '.T.', '.F.', 'NIL' },                                           31,            120,           '999',        250,         .F.,               .F.,           .F.,           30,         .F.,             31,         .F.,            .F.,       .F.,           .F.,          .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::a3State[j]           := aResults[14]
      ::aValue[j]            := IIF( aResults[1] == 1, '.T.', IIF( aResults[1] == 2 .OR. ! ::a3State[j], '.F.', 'NIL' ) )
      oControl:Value         := &( ::aValue[j] )
      ::aCaption[j]          := aResults[2]
      oControl:Caption       := aResults[2]
      ::aToolTip[j]          := aResults[3]
      oControl:ToolTip       := aResults[3]
      ::aHelpID[j]           := aResults[4]
      ::aField[j]            := aResults[5]
      ::aTransparent[j]      := aResults[6]
      ::aEnabled[j]          := aResults[7]
      ::aVisible[j]          := aResults[8]
      ::aName[j]             := IIF( Empty( aResults[9] ), ::aName[j], aResults[9] )
      ::aNoTabStop[j]        := aResults[10]
      ::aCObj[j]             := aResults[11]
      ::aAutoPlay[j]         := aResults[12]
      ::aRTL[j]              := aResults[13]
      ::aThemed[j]           := aResults[15]
      ::aLeft[j]             := aResults[16]
   ENDIF

   IF ::aCtrlType[j] == 'LIST'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Value',      'Items',     'ToolTip',     'MultiSelect',     'HelpID',     'Break',     'NoTabStop',     'Sort',     'Name',     'Enabled',     'Visible',     'Obj',      'RTL',     'NoVScroll',     'Image',     'Fit',     'TextHeight',     'SubClass' }
      aInitValues := { ::avaluen[j], ::aitems[j], ::atooltip[j], ::amultiselect[j], ::aHelpID[j], ::abreak[j], ::anotabstop[j], ::asort[j], ::aname[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aRTL[j], ::aNoVScroll[j], ::aImage[j], ::aFit[j], ::aTextHeight[j], ::aSubClass[j] }
      aFormats    := { '999',        800,         120,           .F.,               '999',        .F.,         .F.,             .F.,        30,         .F.,           .F.,           31,         .F.,       .F.,             250,         .F.,       '999',            .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::avaluen[j]           := aResults[01]
      oControl:value         := aResults[01]
      ::aitems[j]            := aResults[02]
      ::atooltip[j]          := aResults[03]
      oControl:tooltip       := aResults[03]
      ::amultiselect[j]      := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::abreak[j]            := aResults[06]
      ::anotabstop[j]        := aResults[07]
      ::asort[j]             := aResults[08]
      ::aname[j]             := IIF( Empty( aResults[09] ), ::aName[j], aResults[09] )
      ::aenabled[j]          := aResults[10]
      ::avisible[j]          := aResults[11]
      ::acobj[j]             := aResults[12]
      ::aRTL[j]              := aResults[13]
      ::aNoVScroll[j]        := aResults[14]
      ::aImage[j]            := aResults[15]
      ::aFit[j]              := aResults[16]
      ::aTextHeight[j]       := aResults[17]
      ::aSubClass[j]         := aResults[18]
   ENDIF

   IF ::aCtrlType[j] == 'BROWSE'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Headers',     'Widths',     'WorkArea',     'Fields',     'Value ',     'ToolTip',     'Valid',     'ValidMessages',  'ReadOnly',      'Lock',     'Delete',     'NoLines',     'Image',     'Justify',     'HelpID',     'Name',     'Enabled',     'Visible',     "When",    "DynamicBackColor",       "DynamicForeColor",     "ColumnControls",     "InputMask",     "InPlace",     "Edit",     "Append",     'Obj',      'Break',     'RTL',     'NoTabStop',     'FullMove',  'UseButtons',  'NoHeaders',     'HeaderImages',     'ImagesAlign',     'SelectedColors',  'EditKeys',     'DoubleBuffer',     'SingleBuffer',     'FocusRect',     'NoFocusRect',     'PaintLeftMargin',  'FixedCols',     'FixedWidths',     'LikeExcel',     'DeleteWhen',     'DeleteMsg',     'NoDeleteMsg',  'FixedControls',  'DynamicControls',  'FixedBlocks',   'DynamicBlocks',  'BeforeColMove',     'AfterColMove',     'BeforeColSize',     'AfterColSize',     'BeforeAutoFit',     'ExtDblClick',     'NoVScroll',     'NoRefresh',     'ForceRefresh',     'ReplaceField',     'SubClass',     'ColumnInfo',     'RecCount',     'Descending',  'Synchronized',  'UnSynchronized',  'UpdateColors',     'UpdateAll' }
      aInitValues := { ::aheaders[j], ::awidths[j], ::aworkarea[j], ::afields[j], ::aValueN[j], ::atooltip[j], ::avalid[j], ::avalidmess[j],   ::areadonlyb[j], ::alock[j], ::adelete[j], ::anolines[j], ::aimage[j], ::ajustify[j], ::aHelpID[j], ::aname[j], ::aenabled[j], ::avisible[j], ::awhen[j] , ::adynamicbackcolor[j], ::adynamicforecolor[j], ::acolumncontrols[j], ::ainputmask[j], ::ainplace[j], ::aedit[j], ::aappend[j], ::acobj[j], ::aBreak[j], ::aRTL[j], ::anotabstop[j], ::aFull[j],   ::aButtons[j], ::aNoHeaders[j], ::aHeaderImages[j], ::aImagesAlign[j], ::aSelColor[j],     ::aEditKeys[j], ::aDoubleBuffer[j], ::aSingleBuffer[j], ::aFocusRect[j], ::aNoFocusRect[j], ::aPLM[j],           ::aFixedCols[j], ::aFixedWidths[j], ::aLikeExcel[j], ::aDeleteWhen[j], ::aDeleteMsg[j], ::aNoDelMsg[j], ::aFixedCtrls[j], ::aDynamicCtrls[j], ::aFixBlocks[j], ::aDynBlocks[j],   ::aBeforeColMove[j], ::aAfterColMove[j], ::aBeforeColSize[j], ::aAfterColSize[j], ::aBeforeAutoFit[j], ::aExtDblClick[j], ::anovscroll[j], ::aNoRefresh[j], ::aForceRefresh[j], ::aReplaceField[j], ::aSubClass[j], ::aColumnInfo[j], ::aRecCount[j], ::aDescend[j], ::aSync[j],       ::aUnSync[j],       ::aUpdateColors[j], ::aUpdate[j] }
      aFormats    := { 800,           800,          80,             800,          '999999',     250,           800,         800,              800,             .T.,        .F.,          .F.,           800,         800,           '99999',      30,         .F.,           .F.,           800,       800,                      800,                    800,                  800,             .F.,           .F.,        .F.,          31,         .F.,         .F.,       .F.,             .F.,         .F.,           .F.,             250,                250,               250,               250,            .F.,                .F.,                .F.,             .F.,               .F.,                .F.,             .F.,               .F.,             250,              250,             .F.,            .F.,              .F.,                .F.,             .F.,              250,                 250,                250,                 250,                250,                 .F.,               .F.,             .F.,             .F.,                250,                250,            250,              .F.,            .F.,           .F.,             .F.,               .F.,                .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aheaders[j]          := aResults[01]
      ::awidths[j]           := aResults[02]
      ::aworkarea[j]         := aResults[03]
      ::afields[j]           := aResults[04]
      ::aValueN[j]           := aResults[05]
      ::atooltip[j]          := aResults[06]
      ::avalid[j]            := aResults[07]
      ::avalidmess[j]        := aResults[08]
      ::areadonlyb[j]        := aResults[09]
      ::alock[j]             := aResults[10]
      ::adelete[j]           := aResults[11]
      ::anolines[j]          := aResults[12]
      ::aimage[j]            := aResults[13]
      ::ajustify[j]          := aResults[14]
      ::aHelpID[j]           := aResults[15]
      ::aname[j]             := IIF( Empty( aResults[16] ), ::aname[j], aResults[16] )
      ::aenabled[j]          := aResults[17]
      ::avisible[j]          := aResults[18]
      ::awhen[j]             := aResults[19]
      ::adynamicbackcolor[j] := aResults[20]
      ::adynamicforecolor[j] := aResults[21]
      ::acolumncontrols[j]   := aResults[22]
      ::ainputmask[j]        := aResults[23]
      ::ainplace[j]          := aResults[24]
      ::aedit[j]             := aResults[25]
      ::aappend[j]           := aResults[26]
      ::acobj[j]             := aResults[27]
      ::aBreak[j]            := aResults[28]
      ::aRTL[j]              := aResults[29]
      ::anotabstop[j]        := aResults[30]
      ::aFull[j]             := aResults[31]
      ::aButtons[j]          := aResults[32]
      ::aNoHeaders[j]        := aResults[33]
      ::aHeaderImages[j]     := aResults[34]
      ::aImagesAlign[j]      := aResults[35]
      ::aSelColor[j]         := aResults[36]
      ::aEditKeys[j]         := aResults[37]
      ::aDoubleBuffer[j]     := aResults[38]
      ::aSingleBuffer[j]     := aResults[39]
      ::aFocusRect[j]        := aResults[40]
      ::aNoFocusRect[j]      := aResults[41]
      ::aPLM[j]              := aResults[42]
      ::aFixedCols[j]        := aResults[43]
      ::aFixedWidths[j]      := aResults[44]
      ::aLikeExcel[j]        := aResults[45]
      ::aDeleteWhen[j]       := aResults[46]
      ::aDeleteMsg[j]        := aResults[47]
      ::aNoDelMsg[j]         := aResults[48]
      ::aFixedCtrls[j]       := aResults[49]
      ::aDynamicCtrls[j]     := aResults[50]
      ::aFixBlocks[j]        := aResults[51]
      ::aDynBlocks[j]        := aResults[52]
      ::aBeforeColMove[j]    := aResults[53]
      ::aAfterColMove[j]     := aResults[54]
      ::aBeforeColSize[j]    := aResults[55]
      ::aAfterColSize[j]     := aResults[56]
      ::aBeforeAutoFit[j]    := aResults[57]
      ::aExtDblClick[j]      := aResults[58]
      ::anovscroll[j]        := aResults[59]
      ::aNoRefresh[j]        := aResults[60]
      ::aForceRefresh[j]     := aResults[61]
      ::aReplaceField[j]     := aResults[62]
      ::aSubClass[j]         := aResults[63]
      ::aColumnInfo[j]       := aResults[64]
      ::aRecCount[j]         := aResults[65]
      ::aDescend[j]          := aResults[66]
      ::aSync[j]             := aResults[67]
      ::aUnSync[j]           := aResults[68]
      ::aUpdateColors[j]     := aResults[69]
      ::aUpdate[j]           := aResults[70]
   ENDIF

   IF ::aCtrlType[j] == 'XBROWSE'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Headers',     'Widths',     'WorkArea',     'Fields',     'Value ',     'ToolTip',     'Valid',     'ValidMessages',  'ReadOnly',      'Lock',     'Delete',     'NoLines',     'Image',     'Justify',     'HelpID',     'Name',     'Enabled',     'Visible',     "When",    "DynamicBackColor",       "DynamicForeColor",     "ColumnControls",     "InputMask",     "InPlace",     "Edit",     "Append",     'Obj',      'Break',     'RTL',     'NoTabStop',     'FullMove',  'UseButtons',  'NoHeaders',     'HeaderImages',     'ImagesAlign',     'SelectedColors',  'EditKeys',     'DoubleBuffer',     'SingleBuffer',     'FocusRect',     'NoFocusRect',     'PaintLeftMargin',  'FixedCols',     'FixedWidths',     'LikeExcel',     'DeleteWhen',     'DeleteMsg',     'NoDeleteMsg',  'FixedControls',  'DynamicControls',  'FixedBlocks',   'DynamicBlocks',  'BeforeColMove',     'AfterColMove',     'BeforeColSize',     'AfterColSize',     'BeforeAutoFit',     'ExtDblClick',     'NoVScroll',     'ReplaceField',     'SubClass',     'ColumnInfo',     'RecCount',     'Descending',  'UpdateColors',     'NoShowEmptyRow',  'NoModalEdit',    'NavigateBycell' }
      aInitValues := { ::aheaders[j], ::awidths[j], ::aworkarea[j], ::afields[j], ::aValueN[j], ::atooltip[j], ::avalid[j], ::avalidmess[j],   ::areadonlyb[j], ::alock[j], ::adelete[j], ::anolines[j], ::aimage[j], ::ajustify[j], ::aHelpID[j], ::aname[j], ::aenabled[j], ::avisible[j], ::awhen[j] , ::adynamicbackcolor[j], ::adynamicforecolor[j], ::acolumncontrols[j], ::ainputmask[j], ::ainplace[j], ::aedit[j], ::aappend[j], ::acobj[j], ::aBreak[j], ::aRTL[j], ::anotabstop[j], ::aFull[j],   ::aButtons[j], ::aNoHeaders[j], ::aHeaderImages[j], ::aImagesAlign[j], ::aSelColor[j],     ::aEditKeys[j], ::aDoubleBuffer[j], ::aSingleBuffer[j], ::aFocusRect[j], ::aNoFocusRect[j], ::aPLM[j],           ::aFixedCols[j], ::aFixedWidths[j], ::aLikeExcel[j], ::aDeleteWhen[j], ::aDeleteMsg[j], ::aNoDelMsg[j], ::aFixedCtrls[j], ::aDynamicCtrls[j], ::aFixBlocks[j], ::aDynBlocks[j],   ::aBeforeColMove[j], ::aAfterColMove[j], ::aBeforeColSize[j], ::aAfterColSize[j], ::aBeforeAutoFit[j], ::aExtDblClick[j], ::anovscroll[j], ::aReplaceField[j], ::aSubClass[j], ::aColumnInfo[j], ::aRecCount[j], ::aDescend[j], ::aUpdateColors[j], ::aShowNone[j],     ::aNoModalEdit[j], ::aByCell[j] }
      aFormats    := { 800,           800,          80,             800,          '999999',     250,           800,         800,              800,             .T.,        .F.,          .F.,           800,         800,           '99999',      30,         .F.,           .F.,           800,       800,                      800,                    800,                  800,             .F.,           .F.,        .F.,          31,         .F.,         .F.,       .F.,             .F.,         .F.,           .F.,             250,                250,               250,               250,            .F.,                .F.,                .F.,             .F.,               .F.,                .F.,             .F.,               .F.,             250,              250,             .F.,            .F.,              .F.,                .F.,             .F.,              250,                 250,                250,                 250,                250,                 .F.,               .F.,             250,                250,            250,              .F.,            .F.,           .F.,                .F.,               .F.,               .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aheaders[j]          := aResults[01]
      ::awidths[j]           := aResults[02]
      ::aworkarea[j]         := aResults[03]
      ::afields[j]           := aResults[04]
      ::aValueN[j]           := aResults[05]
      ::atooltip[j]          := aResults[06]
      ::avalid[j]            := aResults[07]
      ::avalidmess[j]        := aResults[08]
      ::areadonlyb[j]        := aResults[09]
      ::alock[j]             := aResults[10]
      ::adelete[j]           := aResults[11]
      ::anolines[j]          := aResults[12]
      ::aimage[j]            := aResults[13]
      ::ajustify[j]          := aResults[14]
      ::aHelpID[j]           := aResults[15]
      ::aname[j]             := IIF( Empty( aResults[16] ), ::aname[j], aResults[16] )
      ::aenabled[j]          := aResults[17]
      ::avisible[j]          := aResults[18]
      ::awhen[j]             := aResults[19]
      ::adynamicbackcolor[j] := aResults[20]
      ::adynamicforecolor[j] := aResults[21]
      ::acolumncontrols[j]   := aResults[22]
      ::ainputmask[j]        := aResults[23]
      ::ainplace[j]          := aResults[24]
      ::aedit[j]             := aResults[25]
      ::aappend[j]           := aResults[26]
      ::acobj[j]             := aResults[27]
      ::aBreak[j]            := aResults[28]
      ::aRTL[j]              := aResults[29]
      ::anotabstop[j]        := aResults[30]
      ::aFull[j]             := aResults[31]
      ::aButtons[j]          := aResults[32]
      ::aNoHeaders[j]        := aResults[33]
      ::aHeaderImages[j]     := aResults[34]
      ::aImagesAlign[j]      := aResults[35]
      ::aSelColor[j]         := aResults[36]
      ::aEditKeys[j]         := aResults[37]
      ::aDoubleBuffer[j]     := aResults[38]
      ::aSingleBuffer[j]     := aResults[39]
      ::aFocusRect[j]        := aResults[40]
      ::aNoFocusRect[j]      := aResults[41]
      ::aPLM[j]              := aResults[42]
      ::aFixedCols[j]        := aResults[43]
      ::aFixedWidths[j]      := aResults[44]
      ::aLikeExcel[j]        := aResults[45]
      ::aDeleteWhen[j]       := aResults[46]
      ::aDeleteMsg[j]        := aResults[47]
      ::aNoDelMsg[j]         := aResults[48]
      ::aFixedCtrls[j]       := aResults[49]
      ::aDynamicCtrls[j]     := aResults[50]
      ::aFixBlocks[j]        := aResults[51]
      ::aDynBlocks[j]        := aResults[52]
      ::aBeforeColMove[j]    := aResults[53]
      ::aAfterColMove[j]     := aResults[54]
      ::aBeforeColSize[j]    := aResults[55]
      ::aAfterColSize[j]     := aResults[56]
      ::aBeforeAutoFit[j]    := aResults[57]
      ::aExtDblClick[j]      := aResults[58]
      ::anovscroll[j]        := aResults[59]
      ::aReplaceField[j]     := aResults[60]
      ::aSubClass[j]         := aResults[61]
      ::aColumnInfo[j]       := aResults[62]
      ::aRecCount[j]         := aResults[63]
      ::aDescend[j]          := aResults[64]
      ::aUpdateColors[j]     := aResults[65]
      ::aShowNone[j]         := aResults[66]
      ::aNoModalEdit[j]      := aResults[67]
      ::aByCell[j]           := aResults[68]
   ENDIF

   IF ::aCtrlType[j] == 'RADIOGROUP'
      cTitle := cNameW + " properties"
      aLabels     := { 'Value',      'Options',   'ToolTip',     'Spacing',     'HelpID',     'Transparent',     'Name',     'Enabled',     'Visible',     'Obj',      'RTL',     'NoTabStop',     'AutoSize',     'Vertical',     'Themed',     'Background',     'SubClass' }
      aInitValues := { ::avaluen[j], ::aitems[j], ::atooltip[j], ::aspacing[j], ::aHelpID[j], ::atransparent[j], ::aname[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aRTL[j], ::aNoTabStop[j], ::aAutoPlay[j], ::aVertical[j], ::aThemed[j], ::aBackground[j], ::SubClass[j] }
      aFormats    := { '999',        250,         120,           '999',         '999',        .F.,               30,         .F.,           .F.,           31,         .F.,       .F.,             .F.,            .F.,            .F.,          250,              250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      IF ! IsValidArray( aResults[02] )
         MsgStop( 'Options must be a valid array with 2 or more items.',  'ooHG IDE+' )
         RETURN NIL
      ENDIF
      cItems := &( aResults[02] )
      IF Len( cItems ) < 2
         MsgStop( 'Options must be a valid array with 2 or more items.',  'ooHG IDE+' )
         RETURN NIL
      ENDIF
      ::aValueN[j]           := aResults[01]
      ::aItems[j]            := aResults[02]
      ::aToolTip[j]          := aResults[03]
      oControl:ToolTip       := aResults[03]
      ::aSpacing[j]          := aResults[04]
      oControl:Height        := aResults[04] * Len( cItems ) + 8
      ::aHelpID[j]           := aResults[05]
      ::aTransparent[j]      := aResults[06]
      ::aName[j]             := IIF( Empty( aResults[07] ), ::aName[j], aResults[07] )
      ::aEnabled[j]          := aResults[08]
      ::aVisible[j]          := aResults[09]
      ::aCObj[j]             := aResults[10]
      ::aRTL[j]              := aResults[11]
      ::aNoTabStop[j]        := aResults[12]
      ::aAutoPlay[j]         := aResults[13]
      ::aVertical[j]         := aResults[14]
      ::aThemed[j]           := aResults[15]
      ::aBackground[j]       := aResults[16]
      ::aSubClass[j]         := aResults[17]
   ENDIF

   IF ::aCtrlType[j] == 'COMBO'
      cTitle := cNameW + " properties"
      aLabels     := { 'Value',      'Items',     'ToolTip',     'HelpID',     'NoTabStop',     'Sort',     'ItemSource',     'Enabled',     'Visible',     'Valuesource',     'Name',     "DisplayEdit",     'Obj',      'ItemImageNumber',     'ImageSource',     'FirstItem',     'ListWidth',     'DelayedLoad',     'Incremental',     'IntegralHeight',     'Refresh',     'NoRefresh',     'SourceOrder',     'SearchLapse',     'SubClass' }
      aInitValues := { ::avaluen[j], ::aitems[j], ::atooltip[j], ::aHelpID[j], ::anotabstop[j], ::asort[j], ::aitemsource[j], ::aenabled[j], ::avisible[j], ::avaluesource[j], ::aname[j], ::adisplayedit[j], ::acobj[j], ::aItemImageNumber[j], ::aImageSource[j], ::aFirstItem[j], ::aListWidth[j], ::aDelayedLoad[j], ::aIncremental[j], ::aIntegralHeight[j], ::aRefresh[j], ::aNoRefresh[j], ::aSourceOrder[j], ::aSearchLapse[j], ::aSubClass[j] }
      aFormats    := { '999',        250,         120,           '999',        .F.,             .F.,        100,              .T.,           .T.,           100,               30,         .F.,               31,         250,                   250,               .F.,             '999999',        .F.,               .F.,               .F.,                  .F.,           .F.,             250,               '999999',          250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::avaluen[j]           := aResults[1]
      ::aItems[j]            := IIF( Empty( aResults[7] ), '', aResults[2] )
      ::atooltip[j]          := aResults[3]
      oControl:tooltip       := aResults[3]
      ::aHelpID[j]           := aResults[4]
      ::anotabstop[j]        := aResults[5]
      ::asort[j]             := aResults[6]
      ::aitemsource[j]       := aResults[7]
      ::aenabled[j]          := aResults[8]
      ::avisible[j]          := aResults[9]
      ::avaluesource[j]      := aResults[10]
      ::aname[j]             := IIF( Empty( aResults[11] ), ::aName[j], aResults[11] )
      ::adisplayedit[j]      := aResults[12]
      ::acobj[j]             := aResults[13]
      ::aItemImageNumber[j]  := aResults[14]
      ::aImageSource[j]      := aResults[15]
      ::aFirstItem[j]        := aResults[16]
      ::aListWidth[j]        := aResults[17]
      ::aDelayedLoad[j]      := aResults[18]
      ::aIncremental[j]      := aResults[19]
      ::aIntegralHeight[j]   := aResults[20]
      ::aRefresh[j]          := aResults[21]
      ::aNoRefresh[j]        := aResults[22]
      ::aSourceOrder[j]      := aResults[23]
      ::aSearchLapse[j]      := aResults[24]
      ::aSubClass[j]         := aResults[25]
   ENDIF

   IF ::aCtrlType[j] == 'CHECKBTN'
      cTitle := cNameW + " properties"
      aLabels     := { 'Value',      'Caption',     'ToolTip',     'HelpID',     'Name',     'Enabled',     'Visible',     "NoTabStop",     'Obj',      'RTL',     'Picture',     'Buffer',     'HBitmap',     'NoLoadTransparent',  'ForceScale',     'Field',     'No3DColors',     'Fit',     'DIBSection' }
      aInitValues := { ::avaluel[j], ::acaption[j], ::atooltip[j], ::aHelpID[j], ::aname[j], ::aenabled[j], ::avisible[j], ::anotabstop[j], ::acobj[j], ::aRTL[j], ::aPicture[j], ::aBuffer[j], ::aHBitmap[j], ::aNoLoadTrans[j],     ::aForceScale[j], ::aField[j], ::aNo3DColors[j], ::aFit[j], ::aDIBSection[j] }
      aFormats    := { .F.,          31,            120,           '999',        30,         .F.,           .F.,           .F.,             31,         .F.,       250,           250,          250,           .F.,                  .F.,              250,         .F.,              .F.,       .F. }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::avaluel[j] := aResults[1]
      oControl:value := aResults[1]
      IF Empty( aResults[2] )
         ::acaption[j] := aResults[2]
         oControl:caption := aResults[2]
      ELSE
         ::acaption[j] := ""
         oControl:caption := cName
      ENDIF
      ::atooltip[j] := aResults[3]
      oControl:tooltip := aResults[3]
      ::aHelpID[j] := aResults[4]
      IF ! Empty( aResults[5] )
         ::aname[j] := aResults[5]
      ENDIF
      ::aenabled[j] := aResults[6]
      ::avisible[j] := aResults[7]
      ::anotabstop[j] := aResults[8]
      ::acobj[j] := aResults[9]

      ::aRTL[j] := aResults[10]
      ::aPicture[j] := aResults[11]
      ::aBuffer[j] := aResults[12]
      ::aHBitmap[j] := aResults[13]
      ::aNoLoadTrans[j] := aResults[14]
      ::aForceScale[j] := aResults[15]
      ::aField[j] := aResults[16]
      ::aNo3DColors[j] := aResults[17]
      ::aFit[j] := aResults[18]
      ::aDIBSection[j] := aResults[19]
   ENDIF

   IF ::aCtrlType[j] == 'PICCHECKBUTT'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Value',      'Picture',     'ToolTip',     'HelpID',     'Name',     'Enabled',     'Visible',     "NoTabStop",     'Obj',      'SubClass',     'Buffer',     'HBitmap',     'NoLoadTransparent',  'ForceScale',     'Field',     'No3DColors',     'AutoFit',  'DIBSection',     'Themed',     'ImageMargin',     'Align' }
      aInitValues := { ::avaluel[j], ::apicture[j], ::atooltip[j], ::aHelpID[j], ::aname[j], ::aenabled[j], ::avisible[j], ::anotabstop[j], ::acobj[j], ::aSubClass[j], ::aBuffer[j], ::aHBitmap[j], ::aNoLoadTrans[j],     ::aForceScale[j], ::aField[j], ::aNo3DColors[j], ::aFit[j],   ::aDIBSection[j], ::aThemed[j], ::aImageMargin[j],  IIF( ::aJustify[j] == "BOTTOM",  1,  IIF( ::aJustify[j] == "CENTER",  2,  IIF( ::aJustify[j] == "LEFT",  3,  IIF( ::aJustify[j] == "RIGHT",  4,  IIF( ::aJustify[j] == "TOP",  5,  6 ) ) ) ) ) }
      aFormats    := { .F.,          31,            250,           '999',        30,         .F.,           .F.,           .F.,             31,         250,            250,          250,            .F.,                 .F.,              250,         .F.,              .F.,        .F.,              .F.,          250,               { 'BOTTOM',  'CENTER',  'LEFT',  'RIGHT',  'TOP',  'NONE' } }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aValueL[j]           := aResults[01]
      oControl:value         := aResults[01]
      ::aPicture[j]          := aResults[02]
      ::aToolTip[j]          := aResults[03]
      oControl:ToolTip       := aResults[03]
      ::aHelpID[j]           := aResults[04]
      ::aName[j]             := IIF( Empty( aResults[05] ), ::aName[j], aResults[05] )
      ::aEnabled[j]          := aResults[06]
      ::aVisible[j]          := aResults[07]
      ::aNoTabStop[j]        := aResults[08]
      ::aCObj[j]             := aResults[09]
      ::aSubClass[j]         := aResults[10]
      ::aBuffer[j]           := aResults[11]
      ::aHBitmap[j]          := aResults[12]
      ::aNoLoadTrans[j]      := aResults[13]
      ::aForceScale[j]       := aResults[14]
      ::aField[j]            := aResults[15]
      ::aNo3DColors[j]       := aResults[16]
      ::aFit[j]              := aResults[17]
      ::aDIBSection[j]       := aResults[18]
      ::aThemed[j]           := aResults[19]
      ::aImageMargin[j]      := aResults[20]
      ::aJustify[j]          := IIF( aResults[21] == 1,  'BOTTOM',  IIF( aResults[21] == 2,  'CENTER',  IIF( aResults[21] == 3,  'LEFT',  IIF( aResults[21] == 4,  'RIGHT',  IIF( aResults[21] == 5,  'TOP',  '' ) ) ) ) )
   ENDIF

   IF ::aCtrlType[j] == 'PICBUTT'
      cTitle       := cNameW + " properties"
      aLabels     := { 'Picture',     'ToolTip',     'HelpID',     'NoTabStop',     'Name',     'Enabled',     'Visible',     'Flat',     'Obj',      'Buffer',     'HBitmap',     'NoLoadTransparent',  'ForceScale',     'No3DColors',     'AutoFit',  'DIBSection',     'Themed',     'ImageMargin',     'Align',                                                                                                                                                                          'Cancel',     'SubClass' }
      aInitValues := { ::apicture[j], ::atooltip[j], ::aHelpID[j], ::anotabstop[j], ::aname[j], ::aenabled[j], ::avisible[j], ::aflat[j], ::acobj[j], ::aBuffer[j], ::aHBitmap[j], ::aNoLoadTrans[j],     ::aForceScale[j], ::aNo3DColors[j], ::aFit[j],   ::aDIBSection[j], ::aThemed[j], ::aImageMargin[j],  IIF( ::aJustify[j] == "BOTTOM",  1,  IIF( ::aJustify[j] == "CENTER",  2,  IIF( ::aJustify[j] == "LEFT",  3,  IIF( ::aJustify[j] == "RIGHT",  4,  IIF( ::aJustify[j] == "TOP",  5,  6 ) ) ) ) ), ::aCancel[j], ::aSubClass[j] }
      aFormats    := { 30,            120,           '999',        .F.,             30,         .T.,           .T.,           .F.,        31,         250,          250,           .F.,                  .F.,              .F.,              .F.,        .F.,              .F.,          120,               { 'BOTTOM',  'CENTER',  'LEFT',  'RIGHT',  'TOP',  'NONE' },                                                                                                                           .F.,          250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aPicture[j]          := aResults[01]
      ::aToolTip[j]          := aResults[02]
      oControl:ToolTip       := aResults[02]
      ::aHelpID[j]           := aResults[03]
      ::aNoTabStop[j]        := aResults[04]
      ::aName[j]             := IIF( Empty( aResults[05] ), ::aName[j], aResults[05] )
      ::aEnabled[j]          := aResults[06]
      ::aVisible[j]          := aResults[07]
      ::aFlat[j]             := aResults[08]
      ::aCObj[j]             := aResults[09]
      ::aBuffer[j]           := aResults[10]
      ::aHBitmap[j]          := aResults[11]
      ::aNoLoadTrans[j]      := aResults[12]
      ::aForceScale[j]       := aResults[13]
      ::aNo3DColors[j]       := aResults[14]
      ::aFit[j]              := aResults[15]
      ::aDIBSection[j]       := aResults[16]
      ::aThemed[j]           := aResults[17]
      ::aImageMargin[j]      := aResults[18]
      ::aJustify[j]          := IIF( aResults[19] == 1,  'BOTTOM',  IIF( aResults[19] == 2,  'CENTER',  IIF( aResults[19] == 3,  'LEFT',  IIF( aResults[19] == 4,  'RIGHT',  IIF( aResults[19] == 5,  'TOP',  '' ) ) ) ) )
      ::aCancel[j]           := aResults[20]
      ::aSubClass[j]         := aResults[21]
   ENDIF

   IF ::aCtrlType[j] == 'IMAGE'
      cTitle       := cNameW + " properties"
      aLabels     := { 'Picture',     'ToolTip',     'HelpID',     'Stretch',     'Name',     'Enabled',     'Visible',     'Obj',      "ClientEdge",     "Border",     'Transparent',     'SubClass',     'RTL',     'Buffer',     'HBitmap',     'DIBSection',     'No3DColors',     'NoLoadTransparent',  'NoResize',  'WhiteBackground',  'ImageSize',     'ExcludeArea' }
      aInitValues := { ::apicture[j], ::atooltip[j], ::aHelpID[j], ::astretch[j], ::aname[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aclientedge[j], ::aborder[j], ::atransparent[j], ::aSubClass[j], ::aRTL[j], ::aBuffer[j], ::aHBitmap[j], ::aDIBSection[j], ::aNo3DColors[j], ::aNoLoadTrans[j],     ::aFit[j],    ::aWhiteBack[j],     ::aImageSize[j], ::aExclude[j] }
      aFormats    := { 30,            120,           '999',        .F.,           30,         .F.,           .F.,           31,         .F.,              .F.,          .F.,               250,            .F.,       250,          250,           .F.,              .F.,              .F.,                  .F.,         .F.,                .F.,             250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      IF ! Empty( aResults[1] )
         ::apicture[j]       := aResults[1]
      ENDIF
      ::atooltip[j]          := aResults[2]
      ::aHelpID[j]           := aResults[3]
      ::astretch[j]          := aResults[4]
      ::aname[j]             := IIF( Empty( aResults[5] ), ::aName[j], aResults[5] )
      oControl:Value         := ::aName[j]
      ::aenabled[j]          := aResults[6]
      ::avisible[j]          := aResults[7]
      ::acobj[j]             := aResults[8]
      ::aclientedge[j]       := aResults[9]
      ::aborder[j]           := aResults[10]
      ::atransparent[j]      := aResults[11]
      ::aSubClass[j]         := aResults[12]
      ::aRTL[j]              := aResults[13]
      ::aBuffer[j]           := aResults[14]
      ::aHBitmap[j]          := aResults[15]
      ::aDIBSection[j]       := aResults[16]
      ::aNo3DColors[j]       := aResults[17]
      ::aNoLoadTrans[j]      := aResults[18]
      ::aFit[j]              := aResults[19]
      ::aWhiteBack[j]        := aResults[20]
      ::aImageSize[j]        := aResults[21]
      ::aExclude[j]          := aResults[22]
   ENDIF

   IF ::aCtrlType[j] == 'TIMER'
      cTitle := cNameW + " properties"
      aLabels     := { 'Interval',   'Name',     'Enabled',     'Obj',      'SubClass' }
      aInitValues := { ::avaluen[j], ::aname[j], ::aenabled[j], ::acobj[j], ::aSubClass[j] }
      aFormats    := { '9999999',    30,         .F.,           31,         250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
        RETURN NIL
      ENDIF
      ::aValueN[j]           := IIF( aResults[1] > 0, aResults[01], ::aValueN[j] )
      ::aName[j]             := IIF( Empty( aResults[02] ), ::aName[j], aResults[02] )
      oControl:Value         := ::aName[j]
      ::aEnabled[j]          := aResults[03]
      ::aCObj[j]             := aResults[04]
      ::aSubClass[j]         := aResults[05]
   ENDIF

   IF ::aCtrlType[j] == 'ANIMATE'
      cTitle       := cNameW + " properties"
      aLabels     := { 'File',     'AutoPlay',     'Center ',    'Transparent',     'HelpID',     'ToolTip',     'Name',     'Enabled',     'Visible',     'Obj',      'RTL',     'NoTabStop',     'SubClass' }
      aInitValues := { ::afile[j], ::aautoplay[j], ::acenter[j], ::atransparent[j], ::aHelpID[j], ::atooltip[j], ::aname[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aRTL[j], ::aNoTabStop[j], ::aSubClass[j] }
      aFormats    := { 30,         .F.,            .F.,          .F.,               '999',        120,           30,         .F.,           .F.,           31,         .F.,       .F.,             250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
        RETURN NIL
      ENDIF
      ::afile[j]             := aResults[01]
      ::aautoplay[j]         := aResults[02]
      ::acenter[j]           := aResults[03]
      ::atransparent[j]      := aResults[04]
      ::aHelpID[j]           := aResults[05]
      ::atooltip[j]          := aResults[06]
      oControl:tooltip       := aResults[06]
      ::aName[j]             := IIF( Empty( aResults[07] ), ::aName[j], aResults[07] )
      ::aenabled[j]          := aResults[08]
      ::avisible[j]          := aResults[09]
      ::acobj[j]             := aResults[10]
      ::aRTL[j]              := aResults[11]
      ::aNoTabStop[j]        := aResults[12]
      ::aSubClass[j]         := aResults[13]
   ENDIF

   IF ::aCtrlType[j] == 'PLAYER'
      cTitle      := cNameW + " properties"
      aLabels     := { 'File',     'HelpID',     'Name',     'Enabled',     'Visible',     'Obj',      'NoTabStop',     'RTL',     'NoAutoSizeWindow',     'NoAutoSizeMovie',     'NoErrorDlg',     'NoMenu',     'NoOpen',     'NoPlayBar',     'ShowAll',     'ShowMode',     'ShowName',     'ShowPosition',     'SubClass' }
      aInitValues := { ::afile[j], ::aHelpID[j], ::aname[j], ::aenabled[j], ::avisible[j], ::acobj[j], ::aNoTabStop[j], ::aRTL[j], ::aNoAutoSizeWindow[j], ::aNoAutoSizeMovie[j], ::aNoErrorDlg[j], ::aNoMenu[j], ::aNoOpen[j], ::aNoPlayBar[j], ::aShowAll[j], ::aShowMode[j], ::aShowName[j], ::aShowPosition[j], ::aSubClass[j] }
      aFormats    := { 30,         '999',        30,         .F.,           .F.,           31,         .F.,             .F.,       .F.,                    .F.,                   .F.,              .F.,          .F.,          .F.,             .F.,           .F.,            .F.,            .F.,                250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aFile[j]             := aResults[01]
      ::aHelpID[j]           := aResults[02]
      ::aName[j]             := IIF( Empty( aResults[03] ), ::aName[j], aResults[03] )
      ::aEnabled[j]          := aResults[04]
      ::aVisible[j]          := aResults[05]
      ::aCObj[j]             := aResults[06]
      ::aNoTabStop[j]        := aResults[07]
      ::aRTL[j]              := aResults[08]
      ::aNoAutoSizeWindow[j] := aResults[09]
      ::aNoAutoSizeMovie[j]  := aResults[10]
      ::aNoErrorDlg[j]       := aResults[11]
      ::aNoMenu[j]           := aResults[12]
      ::aNoOpen[j]           := aResults[13]
      ::aNoPlayBar[j]        := aResults[14]
      ::aShowAll[j]          := aResults[15]
      ::aShowMode[j]         := aResults[16]
      ::aShowName[j]         := aResults[17]
      ::aShowPosition[j]     := aResults[18]
      ::aSubClass[j]         := aResults[19]
   ENDIF

   IF ::aCtrlType[j] == 'DATEPICKER'
      cTitle       := cNameW + " properties"
      aLabels     := { 'Value',     'ToolTip',     'ShowNone',     'UpDown',     'RightAlign',     'HelpID',     'Field',     'Visible',     'Enabled',     'Name',     'Obj',      'RTL',     'NoTabStop',     'Range',     'NoBorder',   'SubClass' }
      aInitValues := { ::avalue[j], ::atooltip[j], ::ashownone[j], ::aupdown[j], ::arightalign[j], ::aHelpID[j], ::afield[j], ::avisible[j], ::aenabled[j], ::aname[j], ::acobj[j], ::aRTL[j], ::aNoTabStop[j], ::aRange[j], ::aBorder[j], ::aSubClass[j] }
      aFormats    := { 20,          120,           .F.,            .F.,          .F.,              '999',        250,         .T.,           .T.,           30,         31,         .F.,       .F.,             250,         .F.,          250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aValue[j]            := aResults[01]
      ::aToolTip[j]          := aResults[02]
      oControl:ToolTip       := aResults[02]
      ::aShowNone[j]         := aResults[03]
      ::aUpDown[j]           := aResults[04]
      ::aRightAlign[j]       := aResults[05]
      ::aHelpID[j]           := aResults[06]
      ::aField[j]            := aResults[07]
      ::aVisible[j]          := aResults[08]
      ::aEnabled[j]          := aResults[09]
      ::aName[j]             := IIF( Empty( aResults[10] ), ::aName[j], aResults[10] )
      ::aCObj[j]             := aResults[11]
      ::aRTL[j]              := aResults[12]
      ::aNoTabStop[j]        := aResults[13]
      ::aRange[j]            := aResults[14]
      ::aBorder[j]           := aResults[15]
      ::aSubClass[j]         := aResults[16]
   ENDIF

   IF ::aCtrlType[j] == 'TIMEPICKER'
      cTitle       := cNameW + " properties"
      aLabels     := { 'Value',     'ToolTip',     'ShowNone',     'UpDown',     'RightAlign',     'HelpID',     'Field',     'Visible',     'Enabled',     'Name',     'Obj',      'RTL',     'NoTabStop',     'NoBorder',   'SubClass' }
      aInitValues := { ::avalue[j], ::atooltip[j], ::ashownone[j], ::aupdown[j], ::arightalign[j], ::aHelpID[j], ::afield[j], ::avisible[j], ::aenabled[j], ::aname[j], ::acobj[j], ::aRTL[j], ::aNoTabStop[j], ::aBorder[j], ::aSubClass[j] }
      aFormats    := { 20,          120,           .F.,            .F.,          .F.,              '999',        250,         .T.,           .T.,           30,         31,         .F.,       .F.,             .F.,          250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aValue[j]            := aResults[01]
      ::aToolTip[j]          := aResults[02]
      oControl:ToolTip       := aResults[02]
      ::aShowNone[j]         := aResults[03]
      ::aUpDown[j]           := aResults[04]
      ::aRightAlign[j]       := aResults[05]
      ::aHelpID[j]           := aResults[06]
      ::aField[j]            := aResults[07]
      ::aVisible[j]          := aResults[08]
      ::aEnabled[j]          := aResults[09]
      ::aName[j]             := IIF( Empty( aResults[10] ), ::aName[j], aResults[10] )
      ::aCObj[j]             := aResults[11]
      ::aRTL[j]              := aResults[12]
      ::aNoTabStop[j]        := aResults[13]
      ::aBorder[j]           := aResults[14]
      ::aSubClass[j]         := aResults[15]
   ENDIF

   IF ::aCtrlType[j] == 'MONTHCALENDAR'
      cTitle      := cNameW + " properties"
      aLabels     := { 'Value',     'ToolTip',     'NoToday',     'NoTodayCircle',     'WeekNumbers',     'HelpID',     'Visible',     'Enabled',     'Name',     'Obj',      'NoTabStop',     'RTL',     'SubClass' }
      aInitValues := { ::avalue[j], ::atooltip[j], ::anotoday[j], ::anotodaycircle[j], ::aweeknumbers[j], ::aHelpID[j], ::avisible[j], ::aenabled[j], ::aname[j], ::acobj[j], ::anotabstop[j], ::aRTL[j], ::aSubClass[j] }
      aFormats    := { 30,          120,           .F.,           .F.,                 .F.,               '999',        .T.,           .T.,           30,         31,         .F.,             .F.,       250 }
      aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
      IF aResults[1] == NIL
         RETURN NIL
      ENDIF
      ::aValue[j]            := aResults[01]
      ::aToolTip[j]          := aResults[02]
      oControl:ToolTip       := aResults[02]
      ::aNoToday[j]          := aResults[03]
      ::aNoTodayCircle[j]    := aResults[04]
      ::aWeekNumbers[j]      := aResults[05]
      ::aHelpID[j]           := aResults[06]
      ::aVisible[j]          := aResults[07]
      ::aEnabled[j]          := aResults[08]
      ::aName[j]             := IIF( Empty( aResults[09] ), ::aName[j], aResults[09] )
      ::aCObj[j]             := aResults[10]
      ::aNoTabStop[j]        := aResults[11]
      ::aRTL[j]              := aResults[12]
      ::aSubClass[j]         := aResults[13]
   ENDIF

   ::lFsave := .F.
   ::RefreshControlInspector()

   IF ::aCtrlType[j] == 'BUTTON'
      nRow    := oControl:Row
      nCol    := oControl:Col
      nWidth  := oControl:Width
      nHeight := oControl:Height
      oControl:Release()
      oControl := ::CreateControl( aScan( ::ControlType, ::aCtrlType[j] ),  j )
      oControl:Row    := nRow
      oControl:Col    := nCol
      oControl:Width  := nWidth
      oControl:Height := nHeight
      // Dibuja( ::aControlW[j] )
   ENDIF
   // TODO: destroy and recreate control

   ::MisPuntos()
RETURN NIL

//------------------------------------------------------------------------------
METHOD TabEvents( i ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName

   cName := _OOHG_GetNullName( "0" )
   SET INTERACTIVECLOSE ON
   LOAD WINDOW tabevent AS ( cName )
   &cName:Title := "Tab events " + ::aName[i]
   &cName:text_101:Value := ::aOnChange[i]
   CENTER WINDOW ( cName )
   ACTIVATE WINDOW ( cName )
   SET INTERACTIVECLOSE OFF
RETURN NIL

//------------------------------------------------------------------------------
METHOD TabProperties( i, oTab ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cName, oTabProp

   cName := _OOHG_GetNullName( "0" )
   SET INTERACTIVECLOSE ON
   LOAD WINDOW tabprop AS ( cName )
   ON KEY ESCAPE OF ( oTabProp:Name ) ACTION oTabProp:Release()
   oTabProp:Title          := 'Tab properties ' + ::aName[i]
   oTabProp:Text_1:Value   := ::aValue[i]
   oTabProp:Text_2:Value   := ::aName[i]
   oTabProp:Edit_3:Value   := ::aToolTip[i]
   oTabProp:Text_3:Value   := ::aCObj[i]
   oTabProp:Text_4:Value   := ::aSubClass[i]
   oTabProp:Check_2:Value  := ::aButtons[i]
   oTabProp:Check_5:Value  := ::aEnabled[i]
   oTabProp:Check_1:Value  := ::aFlat[i]
   oTabProp:Check_6:Value  := ::aVisible[i]
   oTabProp:Check_3:Value  := ::aHotTrack[i]
   oTabProp:Check_7:Value  := ::aRTL[i]
   oTabProp:Check_4:Value  := ::aVertical[i]
   oTabProp:Check_8:Value  := ::aNoTabStop[i]
   oTabProp:Check_9:Value  := ::aMultiLine[i]
   oTabProp:Check_10:Value := ::aVirtual[i]
   oTabProp:Text_101:Value := ::aCaption[i]
   oTabProp:Edit_2:Value   := ::aImage[i]
   oTabProp:Edit_4:Value   := ::aPageNames[i]
   oTabProp:Edit_5:Value   := ::aPageObjs[i]
   oTabProp:Edit_6:Value   := ::aPageSubClasses[i]
   CENTER WINDOW ( cName )
   ACTIVATE WINDOW ( cName )
   SET INTERACTIVECLOSE OFF
RETURN NIL

//------------------------------------------------------------------------------
METHOD AddTabPage( i, oTab, oTabProp ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nPages

   nPages := oTab:ItemCount

   ::aCaption[i]        := SubStr( ::aCaption[i], 1, Len( ::aCaption[i] ) - 2 ) + ", 'Page " + AllTrim( Str( nPages + 1 ) ) + "' }"
   ::aImage[i]          := SubStr( ::aImage[i], 1, Len( ::aImage[i] ) - 2 ) + ", '' }"
   ::aPageNames[i]      := SubStr( ::aPageNames[i], 1, Len( ::aPageNames[i] ) - 2 ) + ", '' }"
   ::aPageObjs[i]       := SubStr( ::aPageObjs[i], 1, Len( ::aPageObjs[i] ) - 2 ) + ", '' }"
   ::aPageSubClasses[i] := SubStr( ::aPageSubClasses[i], 1, Len( ::aPageSubClasses[i] ) - 2 ) + ", '' }"

   oTabProp:Text_101:Value := ::aCaption[i]
   oTabProp:Edit_2:Value   := ::aImage[i]
   oTabProp:Edit_4:Value   := ::aPageNames[i]
   oTabProp:Edit_5:Value   := ::aPageObjs[i]
   oTabProp:Edit_6:Value   := ::aPageSubClasses[i]

   oTab:Addpage( nPages + 1, 'Page ' + AllTrim( Str( nPages + 1 ) ), '' )
RETURN NIL

*-----------------------------------------------------------------------------*
METHOD DeleteTabPage( i, oTab, oTabProp ) CLASS TFormEditor
*-----------------------------------------------------------------------------*
LOCAL nPages, cName, j

   nPages := oTab:ItemCount
   IF nPages <= 1
      RETURN NIL
   ENDIF

   ::aCaption[i]        := SubStr( ::aCaption[i], 1, Rat( ", ", ::aCaption[i] ) - 1 ) + " }"
   ::aImage[i]          := SubStr( ::aImage[i], 1, Rat( ", ", ::aImage[i] ) - 1 ) + " }"
   ::aPageNames[i]      := SubStr( ::aPageNames[i], 1, Rat( ", ", ::aPageNames[i] ) - 1 ) + " }"
   ::aPageObjs[i]       := SubStr( ::aPageObjs[i], 1, Rat( ", ", ::aPageObjs[i] ) - 1 ) + " }"
   ::aPageSubClasses[i] := SubStr( ::aPageSubClasses[i], 1, Rat( ", ", ::aPageSubClasses[i] ) - 1 ) + " }"

   oTabProp:Text_101:Value := ::aCaption[i]
   oTabProp:Edit_2:Value   := ::aImage[i]
   oTabProp:Edit_4:Value   := ::aPageNames[i]
   oTabProp:Edit_5:Value   := ::aPageObjs[i]
   oTabProp:Edit_6:Value   := ::aPageSubClasses[i]

   cName := ::aControlW[i]
   FOR j := 1 TO ::nControlW
      IF ::aTabPage[j, 1] == cName .and. ::aTabPage[j, 2] == nPages
         ::aTabPage[j, 1] := ''
         ::aTabPage[j, 2] := 0
         ::IniArray( j, '', '' )
       ENDIF
   NEXT j

   oTab:DeletePage( nPages )
   oTab:Visible := .F.
   oTab:Visible := .T.
RETURN NIL

//------------------------------------------------------------------------------
FUNCTION CambiaCap( oTab, oTabProp )
//------------------------------------------------------------------------------
LOCAL i, aCaptions

   IF IsValidArray( oTabProp:text_101:Value )
      aCaptions := &( oTabProp:text_101:Value )
      FOR i := 1 TO Len( aCaptions )
         oTab:Caption( i, aCaptions[i] )
      NEXT i
      RETURN .T.
   ENDIF
   MsgStop( "Caption for pages must be a valid array !!!", 'ooHG IDE+' )
RETURN .F.

//------------------------------------------------------------------------------
FUNCTION CambiaImg( oTabProp )
//------------------------------------------------------------------------------
   IF IsValidArray( oTabProp:Edit_2:Value )
      RETURN .T.
   ENDIF
   MsgStop( "Image for pages must be a valid array !!!", 'ooHG IDE+' )
RETURN .F.

//------------------------------------------------------------------------------
FUNCTION CambiaNam( oTabProp )
//------------------------------------------------------------------------------
   IF IsValidArray( oTabProp:Edit_4:Value )
      RETURN .T.
   ENDIF
   MsgStop( "Names for pages must be a valid array !!!", 'ooHG IDE+' )
RETURN .F.

//------------------------------------------------------------------------------
FUNCTION CambiaObj( oTabProp )
//------------------------------------------------------------------------------
   IF IsValidArray( oTabProp:Edit_5:Value )
      RETURN .T.
   ENDIF
   MsgStop( "Names for pages must be a valid array !!!", 'ooHG IDE+' )
RETURN .F.

//------------------------------------------------------------------------------
FUNCTION CambiaSub( oTabProp )
//------------------------------------------------------------------------------
   IF IsValidArray( oTabProp:Edit_6:Value )
      RETURN .T.
   ENDIF
   MsgStop( "Names for pages must be a valid array !!!", 'ooHG IDE+' )
RETURN .F.

//------------------------------------------------------------------------------
FUNCTION IsValidArray( cArray )
//------------------------------------------------------------------------------
LOCAL nOpen, nClose, i

   nOpen := nClose := 0
   cArray := AllTrim( cArray )
   FOR i := 1 TO Len( cArray )
      IF SubStr( cArray, i, 1 ) == '{'
         nOpen ++
      ELSEIF SubStr( cArray, i, 1 ) == '}'
         nClose ++
      ENDIF
   NEXT i
   IF nOpen #1 .OR. nClose # 1
      RETURN .F.
   ENDIF
RETURN Type( cArray ) == "A"

//------------------------------------------------------------------------------
METHOD Events_Click() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL oControl, cName, x, j, cNameW, cTitle, aLabels, aInitValues, aFormats, aResults

   IF ::nHandleP > 0
      oControl := ::oDesignForm:acontrols[::nHandleP]
      cName := Lower( oControl:Name )
      x := aScan( ::aControlW, { |c| Lower( c ) == cName } )
      IF oControl:Type == 'TAB'
         ::TabEvent( x )
         ::lFSave := .F.
         RETURN NIL
      ELSE
         cName := Lower( oControl:Name )
         FOR j := 1 TO ::ncontrolw
            IF Lower( ::aControlW[j]) == cName
               cNameW := ::aName[j]

               IF ::aCtrlType[j] == 'TEXT'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Enter',    'On Change',    'On GotFocus',    'On LostFocus',    'On TextFilled' }
                  aInitValues := { ::aonenter[j], ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOnTextFilled[j] }
                  aFormats    := { 250,           250,            250,              250,               250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonenter[j]         := aResults[1]
                  ::aonchange[j]        := aResults[2]
                  ::aongotfocus[j]      := aResults[3]
                  ::aonlostfocus[j]     := aResults[4]
                  ::aOnTextFilled[j]    := aResults[5]
               ENDIF

               IF ::aCtrlType[j] == 'BUTTON'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On GotFocus',    'On LostFocus',    'Action',     'On MouseMove' }
                  aInitValues := { ::aongotfocus[j], ::aonlostfocus[j], ::aaction[j], ::aOnMouseMove[j] }
                  aFormats    := { 250,              250,               250,          250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aongotfocus[j]      := aResults[1]
                  ::aonlostfocus[j]     := aResults[2]
                  ::aaction[j]          := aResults[3]
                  ::aOnMouseMove[j]     := aResults[4]
               ENDIF

               IF ::aCtrlType[j] == 'CHECKBOX'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j] }
                  aFormats    := { 250,           250,              250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
                  ::aongotfocus[j]      := aResults[2]
                  ::aonlostfocus[j]     := aResults[3]
               ENDIF

               IF ::aCtrlType[j] == 'IPADDRESS'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',  'On GotFocus',  'On LostFocus' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j]}
                  aFormats    := { 250,           250,              250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
                  ::aongotfocus[j]      := aResults[2]
                  ::aonlostfocus[j]     := aResults[3]
               ENDIF

               IF ::aCtrlType[j] == 'GRID'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On DblClick',    'On Enter',    'On Headclcik',    "On EditCell",    "On QueryData",    "On AborEdit",    "On Delete",    "On HeadRClick" }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aondblclick[j], ::aOnEnter[j], ::aonheadclick[j], ::aoneditcell[j], ::aOnQueryData[j], ::aOnAborEdit[j], ::aOnDelete[j], ::aOnHeadRClick[j] }
                  aFormats    := { 250,            250,              250,               250,              250,           250,               250,              250,               250,              250,            250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
                  ::aongotfocus[j]      := aResults[2]
                  ::aonlostfocus[j]     := aResults[3]
                  ::aondblclick[j]      := aResults[4]
                  ::aonenter[j]         := aResults[5]
                  ::aonheadclick[j]     := aResults[6]
                  ::aoneditcell[j]      := aResults[7]
                  ::aOnQueryData[j]     := aResults[8]
                  ::aOnAbortEdit[j]     := aResults[9]
                  ::aOnDelete[j]        := aResults[10]
                  ::aOnHeadRClick[j]    := aResults[11]
               ENDIF

               IF ::aCtrlType[j] == 'TREE'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On DblClick',    'On Enter',    'On LabelEdit',    'On CheckChange',  'On Drop' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aondblclick[j], ::aOnEnter[j], ::aOnLabelEdit[j], ::aOnCheckChg[j],   ::aOnDrop[j] }
                  aFormats    := { 250,            250,              250,               250,              250,           250,               250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[01]
                  ::aongotfocus[j]      := aResults[02]
                  ::aonlostfocus[j]     := aResults[03]
                  ::aondblclick[j]      := aResults[04]
                  ::aOnEnter[j]         := aResults[05]
                  ::aOnLabelEdit[j]     := aResults[06]
                  ::aOnCheckChg[j]      := aResults[07]
                  ::aOnDrop[j]          := aResults[08]
               ENDIF

               IF ::aCtrlType[j] == 'BROWSE'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On DblClick',    'On HeadClick',    'On EditCell',    'On Append',    'On Enter',    'Action',     'On AbortEdit',    'On Delete',    'On HeadRClick' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aondblclick[j], ::aonheadclick[j], ::aoneditcell[j], ::aonappend[j], ::aonenter[j], ::aAction[j], ::aOnAbortEdit[j], ::aOnDelete[j], ::aOnHeadRClick[j] }
                  aFormats    := { 250,            250,              250,               250,              250,               250,              250,            250,           250,          250,               250,            250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[01]
                  ::aongotfocus[j]      := aResults[02]
                  ::aonlostfocus[j]     := aResults[03]
                  ::aondblclick[j]      := aResults[04]
                  ::aonheadclick[j]     := aResults[05]
                  ::aoneditcell[j]      := aResults[06]
                  ::aonappend[j]        := aResults[07]
                  ::aonenter[j]         := aResults[08]
                  ::aAction[j]          := aResults[09]
                  ::aOnAbortEdit[j]     := aResults[10]
                  ::aOnDelete[j]        := aResults[11]
                  ::aOnHeadRClick[j]    := aResults[12]
               ENDIF

               IF ::aCtrlType[j] == 'XBROWSE'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On DblClick',    'On HeadClick',    'On EditCell',    'On Append',    'On Enter',    'Action',     'On AbortEdit',    'On Delete',    'On HeadRClick' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aondblclick[j], ::aonheadclick[j], ::aoneditcell[j], ::aonappend[j], ::aonenter[j], ::aAction[j], ::aOnAbortEdit[j], ::aOnDelete[j], ::aOnHeadRClick[j] }
                  aFormats    := { 250,            250,              250,               250,              250,               250,              250,            250,           250,          250,               250,            250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[01]
                  ::aongotfocus[j]      := aResults[02]
                  ::aonlostfocus[j]     := aResults[03]
                  ::aondblclick[j]      := aResults[04]
                  ::aonheadclick[j]     := aResults[05]
                  ::aoneditcell[j]      := aResults[06]
                  ::aonappend[j]        := aResults[07]
                  ::aonenter[j]         := aResults[08]
                  ::aAction[j]          := aResults[09]
                  ::aOnAbortEdit[j]     := aResults[10]
                  ::aOnDelete[j]        := aResults[11]
                  ::aOnHeadRClick[j]    := aResults[12]
               ENDIF

               IF ::aCtrlType[j] == 'SPINNER'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j] }
                  aFormats    := { 250,            250,              250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
                  ::aongotfocus[j]      := aResults[2]
                  ::aonlostfocus[j]     := aResults[3]
               ENDIF

               IF ::aCtrlType[j] == 'LIST'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On DblClick',    'On Enter' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOndblclick[j], ::aOnEnter[j] }
                  aFormats    := { 250,            250,              250,               250,              250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
                  ::aongotfocus[j]      := aResults[2]
                  ::aonlostfocus[j]     := aResults[3]
                  ::aondblclick[j]      := aResults[4]
               ENDIF

               IF ::aCtrlType[j] == 'COMBO'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On Enter',    'On DisplayChange',    'On ListDisplay',    'On ListClose',    'On Refresh' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aonenter[j], ::aondisplaychange[j], ::aOnListDisplay[j], ::aOnListClose[j], ::aOnRefresh[j] }
                  aFormats    := { 250,            250,              250,               250,           250,                   250,                 250,               250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
                  ::aongotfocus[j]      := aResults[2]
                  ::aonlostfocus[j]     := aResults[3]
                  ::aonenter[j]         := aResults[4]
                  ::aondisplaychange[j] := aResults[5]
                  ::aOnListDisplay[j]   := aResults[6]
                  ::aOnListClose[j]     := aResults[7]
                  ::aOnRefresh[j]       := aResults[8]
               ENDIF

               IF ::aCtrlType[j] == 'CHECKBTN'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j] }
                  aFormats    := { 250,            250,              250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
                  ::aongotfocus[j]      := aResults[2]
                  ::aonlostfocus[j]     := aResults[3]
               ENDIF

               IF ::aCtrlType[j] == 'PICCHECKBUTT'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On MouseMove' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOnMouseMove[j] }
                  aFormats    := { 250,            250,              250,               250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aOnChange[j]        := aResults[01]
                  ::aOnGotFocus[j]      := aResults[02]
                  ::aOnLostFocus[j]     := aResults[03]
                  ::aOnMouseMove[j]     := aResults[04]
               ENDIF

               IF ::aCtrlType[j] == 'PICBUTT'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On GotFocus',    'On LostFocus',    'Action',     'On MouseMove'}
                  aInitValues := { ::aongotfocus[j], ::aonlostfocus[j], ::aaction[j], ::aOnMouseMove[j] }
                  aFormats    := { 250,              250,               250,          250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aongotfocus[j]      := aResults[01]
                  ::aonlostfocus[j]     := aResults[02]
                  ::aaction[j]          := aResults[03]
                  ::aOnMouseMove[j]     := aResults[04]
               ENDIF

               IF ::aCtrlType[j] == 'IMAGE'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'Action' }
                  aInitValues := { ::aaction[j] }
                  aFormats    := { 250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aaction[j]          := aResults[1]
               ENDIF

               IF ::aCtrlType[j] == 'MONTHCALENDAR'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change' }
                  aInitValues := { ::aonchange[j] }
                  aFormats    := { 250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
               ENDIF

               IF ::aCtrlType[j] == 'TIMER'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'Action' }
                  aInitValues := { ::aaction[j] }
                  aFormats    := { 250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aaction[j]         := aResults[1]
               ENDIF

               IF ::aCtrlType[j] == 'LABEL'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'Action' }
                  aInitValues := { ::aaction[j] }
                  aFormats    := { 250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aaction[j]          := aResults[1]
               ENDIF

               IF ::aCtrlType[j] == 'RADIOGROUP'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change' }
                  aInitValues := { ::aonchange[j] }
                  aFormats    := { 250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
               ENDIF

               IF ::aCtrlType[j] == 'SLIDER'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change' }
                  aInitValues := { ::aonchange[j] }
                  aFormats    := { 250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
               ENDIF

               IF ::aCtrlType[j] == 'DATEPICKER'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On Enter'  }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aonenter[j] }
                  aFormats    := { 250,            250,              250,               250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
                  ::aongotfocus[j]      := aResults[2]
                  ::aonlostfocus[j]     := aResults[3]
                  ::aonenter[j]         := aResults[4]
               ENDIF

               IF ::aCtrlType[j] == 'TIMEPICKER'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On Enter'  }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aonenter[j] }
                  aFormats    := { 250,            250,              250,               250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
                  ::aongotfocus[j]      := aResults[2]
                  ::aonlostfocus[j]     := aResults[3]
                  ::aonenter[j]         := aResults[4]
               ENDIF

               IF ::aCtrlType[j] == 'EDIT'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On HScroll',    'On VScroll' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOnHScroll[j], ::aOnVScroll[j] }
                  aFormats    := { 250,            250,              250,               250,              250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aonchange[j]        := aResults[1]
                  ::aongotfocus[j]      := aResults[2]
                  ::aonlostfocus[j]     := aResults[3]
               ENDIF

               IF ::aCtrlType[j] == 'RICHEDIT'
                  cTitle      := cNameW + " events"
                  aLabels     := { 'On Change',    'On GotFocus',    'On LostFocus',    'On SelChange',    'On HScroll',    'On VScroll' }
                  aInitValues := { ::aonchange[j], ::aongotfocus[j], ::aonlostfocus[j], ::aOnSelChange[j], ::aOnHScroll[j], ::aOnVScroll[j] }
                  aFormats    := { 250,            250,              250,               250,               250,              250 }
                  aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
                  IF aResults[1] == NIL
                     RETURN NIL
                  ENDIF
                  ::aOnChange[j]        := aResults[01]
                  ::aOnGotFocus[j]      := aResults[02]
                  ::aOnLostFocus[j]     := aResults[03]
                  ::aOnSelChange[j]     := aResults[04]
                  ::aOnHScroll[j]       := aResults[05]
                  ::aOnVScroll[j]       := aResults[06]
               ENDIF

            ENDIF
         NEXT j
      ENDIF
   ENDIF

   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD FrmProperties() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cTitle, aLabels, aInitValues, aFormats, aResults

   cTitle      := 'Properties of Form ' + ::cFName
   aLabels     := { 'Title',   'Icon',   'Main',   'Child',   'NoShow',   'Topmost',   'NoMinimize',   'NoMaximize',   'NoSize',   'NoSysMenu',   'NoCaption',   'Modal',   'NotifyIcon',   'NotifyToolTip',   'NoAutoRelease',   'HelpButton',   'Focused',   'Break',   'SplitChild',   'GripperText',   'Cursor',   'VirtualHeight',  'VirtualWidth',  'Obj',   'ModalSize',   'MDI',   'MDIClient',   'MDIChild',   'Internal',   'RTL',   'ClientArea',   'MinWidth',   'MaxWidth',   'MinHeight',   'MaxHeight',   'BackImage',   'Stretch',   'Parent',   'SubClass' }
   aInitValues := { ::cFTitle, ::cficon, ::lfmain, ::lfchild, ::lfnoshow, ::lftopmost, ::lfnominimize, ::lfnomaximize, ::lfnosize, ::lfnosysmenu, ::lfnocaption, ::lfmodal, ::cfnotifyicon, ::cfnotifytooltip, ::lfnoautorelease, ::lfhelpbutton, ::lffocused, ::lfbreak, ::lfsplitchild, ::lfgrippertext, ::cfcursor, ::nfvirtualh,     ::nfvirtualw,    ::cfobj, ::lFModalSize, ::lFMDI, ::lFMDIClient, ::lFMDIChild, ::lFInternal, ::lFRTL, ::lFClientArea, ::nFMinWidth, ::nFMaxWidth, ::nFMinHeight, ::nFMaxHeight, ::cFBackImage, ::lFStretch, ::cFParent, ::cFSubClass }
   aFormats    := { 200,       31,       .F.,      .F.,       .F.,        .F.,         .F.,            .F.,            .F.,        .F.,           .F.,           .F.,       120,            120,               .F.,               .F.,            .F.,         .F.,       .F.,            .F.,             31,         '9999',           '9999',          120,     .F.,           .F.,     .F.,           .F.,          .F.,          .F.,     .F.,            '99999',      '99999',      '99999',       '99999',       250,           .F.,         250,        250 }
   aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
   IF aResults[1] == NIL
      RETURN NIL
   ENDIF

   ::cFTitle              := IIF( HB_IsString(  aResults[01] ), aResults[01], "" )
   ::cFIcon               := IIF( HB_IsString(  aResults[02] ), aResults[02], "" )
   ::lFMain               := IIF( HB_IsLogical( aResults[03] ), aResults[03], .F. )
   ::lFChild              := IIF( HB_IsLogical( aResults[04] ), aResults[04], .F. )
   ::lFNoShow             := IIF( HB_IsLogical( aResults[05] ), aResults[05], .F. )
   ::lFTopmost            := IIF( HB_IsLogical( aResults[06] ), aResults[06], .F. )
   ::lFNominimize         := IIF( HB_IsLogical( aResults[07] ), aResults[07], .F. )
   ::lFNomaximize         := IIF( HB_IsLogical( aResults[08] ), aResults[08], .F. )
   ::lFNoSize             := IIF( HB_IsLogical( aResults[09] ), aResults[09], .F. )
   ::lFNoSysMenu          := IIF( HB_IsLogical( aResults[10] ), aResults[10], .F. )
   ::lFNoCaption          := IIF( HB_IsLogical( aResults[11] ), aResults[11], .F. )
   ::lFModal              := IIF( HB_IsLogical( aResults[12] ), aResults[12], .F. )
   ::cFNotifyIcon         := IIF( HB_IsString(  aResults[13] ), aResults[13], "" )
   ::cFNotifyTooltip      := IIF( HB_IsString(  aResults[14] ), aResults[14], "" )
   ::lFNoAutoRelease      := IIF( HB_IsLogical( aResults[15] ), aResults[15], .F. )
   ::lFHelpButton         := IIF( HB_IsLogical( aResults[16] ), aResults[16], .F. )
   ::lFFocused            := IIF( HB_IsLogical( aResults[17] ), aResults[17], .F. )
   ::lFBreak              := IIF( HB_IsLogical( aResults[18] ), aResults[18], .F. )
   ::lFSplitchild         := IIF( HB_IsLogical( aResults[19] ), aResults[19], .F. )
   ::lFGripperText        := IIF( HB_IsLogical( aResults[20] ), aResults[20], .F. )
   ::cfcursor             := IIF( HB_IsString(  aResults[21] ), aResults[21], "" )
   ::nfvirtualh           := IIF( HB_IsNumeric( aResults[22] ), aResults[22], 0 )
   ::nfvirtualw           := IIF( HB_IsNumeric( aResults[23] ), aResults[23], 0 )
   ::cfobj                := IIF( HB_IsString(  aResults[24] ), aResults[24], "" )
   ::lFModalSize          := IIF( HB_IsLogical( aResults[25] ), aResults[25], .F. )
   ::lFMDI                := IIF( HB_IsLogical( aResults[26] ), aResults[26], .F. )
   ::lFMDIClient          := IIF( HB_IsLogical( aResults[27] ), aResults[27], .F. )
   ::lFMDIChild           := IIF( HB_IsLogical( aResults[28] ), aResults[28], .F. )
   ::lFInternal           := IIF( HB_IsLogical( aResults[29] ), aResults[29], .F. )
   ::cFMoveProcedure      := IIF( HB_IsString(  aResults[30] ), aResults[30], "" )
   ::cFRestoreProcedure   := IIF( HB_IsString(  aResults[31] ), aResults[31], "" )
   ::lFRTL                := IIF( HB_IsLogical( aResults[32] ), aResults[32], .F. )
   ::lFClientArea         := IIF( HB_IsLogical( aResults[33] ), aResults[33], .F. )
   ::cFRClickProcedure    := IIF( HB_IsString(  aResults[34] ), aResults[34], "" )
   ::cFMClickProcedure    := IIF( HB_IsString(  aResults[35] ), aResults[35], "" )
   ::cFDblClickProcedure  := IIF( HB_IsString(  aResults[36] ), aResults[36], "" )
   ::cFRDblClickProcedure := IIF( HB_IsString(  aResults[37] ), aResults[37], "" )
   ::cFMDblClickProcedure := IIF( HB_IsString(  aResults[38] ), aResults[38], "" )
   ::nFMinWidth           := IIF( HB_IsNumeric( aResults[39] ), aResults[39], 0 )
   ::nFMaxWidth           := IIF( HB_IsNumeric( aResults[40] ), aResults[40], 0 )
   ::nFMinHeight          := IIF( HB_IsNumeric( aResults[41] ), aResults[41], 0 )
   ::nFMaxHeight          := IIF( HB_IsNumeric( aResults[42] ), aResults[42], 0 )
   ::cFBackImage          := IIF( HB_IsString(  aResults[43] ), aResults[43], "" )
   ::lFStretch            := IIF( HB_IsLogical( aResults[44] ) .AND. ! Empty( ::cFBackImage ), aResults[44], .F. )
   ::cFParent             := IIF( HB_IsString(  aResults[45] ), aResults[45], "" )
   ::cFSubClass           := IIF( HB_IsString(  aResults[46] ), aResults[46], "" )

   ::oDesignForm:Title := ::cFTitle
   ::lFsave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD FrmEvents() CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL cTitle, aLabels, aInitValues, aFormats, aResults

   cTitle      := 'Form ' + ::cFName + " events"
   aLabels     := { 'On Init',  'On Release',  'On MouseClick',  'On MouseMove',  'On MouseDrag',  'On GotFocus',  'On LostFocus',  'On ScrollUp',  'On ScrollDown',  'On ScrollLeft',  'On ScrollRight',  'On HScrollBox',  'On VScrollBox',  'On Size',  'On Paint',  'On NotifyClick',  "On InteractiveClose",  "On Maximize",  "On Minimize",  'On Move',         'On Restore',         'On RClick',         'On MClick',         'On DblClick',         'On RDblClick',         'On MDblClick' }
   aInitValues := { ::cfoninit, ::cfonrelease, ::cfonmouseclick, ::cfonmousemove, ::cfonmousedrag, ::cfongotfocus, ::cfonlostfocus, ::cfonscrollup, ::cfonscrolldown, ::cfonscrollleft, ::cfonscrollright, ::cfonhscrollbox, ::cfonvscrollbox, ::cfonsize, ::cfonpaint, ::cfonnotifyclick, ::cfoninteractiveclose, ::cfonmaximize, ::cfonminimize, ::cFMoveProcedure, ::cFRestoreProcedure, ::cFRClickProcedure, ::cFMClickProcedure, ::cFDblClickProcedure, ::cFRDblClickProcedure, ::cFMDblClickProcedure  }
   aFormats    := { 250,        250,           250,              250,             250,             250,            250,             250,            250,              250,              250,               250,              250,              250,        250,         250,               250,                    250,            250,            250,               250,                  250,                 250,                 250,                   250,                    250 }
   aResults    := ::myIde:myInputWindow( cTitle, aLabels, aInitValues, aFormats )
   IF aResults[1] == NIL
      RETURN NIL
   ENDIF

   ::cFOnInit             := aResults[01]
   ::cFOnRelease          := aResults[02]
   ::cFOnMouseClick       := aResults[03]
   ::cFOnMouseMove        := aResults[04]
   ::cFOnMouseDrag        := aResults[05]
   ::cFOnGotFocus         := aResults[06]
   ::cFOnLostFocus        := aResults[07]
   ::cFOnScrollUp         := aResults[08]
   ::cFOnScrollDown       := aResults[09]
   ::cFOnScrollLeft       := aResults[10]
   ::cFOnScrollRight      := aResults[11]
   ::cFOnHScrollbox       := aResults[12]
   ::cFOnVScrollbox       := aResults[13]
   ::cFOnSize             := aResults[14]
   ::cFOnPaint            := aResults[15]
   ::cFOnNotifyClick      := aResults[16]
   ::cFOnInteractiveClose := aResults[17]
   ::cFOnMaximize         := aResults[18]
   ::cFOnMinimize         := aResults[19]

   ::lFSave := .F.
RETURN NIL

//------------------------------------------------------------------------------
METHOD Snap( cName ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL nRow, nCol
   IF ::myIde:lSnap
      nRow := ::oDesignForm:&cName:Row
      nCol := ::oDesignForm:&cName:Col
      DO WHILE Mod( nRow, 10 ) # 0
         nRow --
      ENDDO
      DO WHILE Mod( nCol, 10 ) # 0
         nCol --
      ENDDO
      ::oDesignForm:&cName:Row := nRow
      ::oDesignForm:&cName:Col := nCol
   ENDIF
RETURN NIL

//------------------------------------------------------------------------------
METHOD SiEsDEste( ih, cType ) CLASS TFormEditor
//------------------------------------------------------------------------------
LOCAL i, cName

   IF HB_IsNumeric( ih ) .AND. HB_IsString( cType )
      IF ih > 0
         cName := ::oDesignForm:aControls[ih]:Name
         FOR i := 1 TO Len( ::aControlW )
            IF Lower( cName ) == Lower( ::aControlW[i] ) .AND. Lower( ::aCtrlType[i] ) == Lower( cType )
               RETURN .T.
            ENDIF
         NEXT i
      ENDIF
   ENDIF
RETURN .F.


#pragma BEGINDUMP

#define HB_OS_WIN_32_USED
#define _WIN32_WINNT   0x0400
#include <windows.h>
#include "hbapi.h"
#include "hbapiitm.h"
/////#include "wingdi.h"

HB_FUNC ( HB_GETDC )
{
   hb_retnl( (ULONG) GetDC( (HWND) hb_parnl(1) ) ) ;
}

HB_FUNC ( HB_RELEASEDC )
{
   hb_retl( ReleaseDC( (HWND) hb_parnl(1), (HDC) hb_parnl(2) ) ) ;
}

HB_FUNC( SETPIXEL )
{

  hb_retnl( (ULONG) SetPixel( (HDC) hb_parnl( 1 ),
                              hb_parni( 2 )      ,
                              hb_parni( 3 )      ,
                              (COLORREF) hb_parnl( 4 )
                            ) ) ;
}

HB_FUNC ( INTERACTIVESIZEHANDLE )
{

        keybd_event(
                VK_DOWN,
                0,
                0,
                0
        );

        keybd_event(
                VK_RIGHT,
                0,
                0,
                0
        );

        SendMessage( (HWND) hb_parnl(1) , WM_SYSCOMMAND , SC_SIZE , 0 );

}

HB_FUNC ( INTERACTIVEMOVEHANDLE )
{

        keybd_event(
                VK_RIGHT,       // virtual-key code
                0,              // hardware scan code
                0,              // flags specifying various function options
                0               // additional data associated with keystro
        );
        keybd_event(
                VK_LEFT,        // virtual-key code
                0,              // hardware scan code
                0,              // flags specifying various function options
                0               // additional data associated with keystro
        );

        SendMessage( (HWND) hb_parnl(1) , WM_SYSCOMMAND , SC_MOVE ,10 );

}

#pragma ENDDUMP

/*
 * EOF
 */
