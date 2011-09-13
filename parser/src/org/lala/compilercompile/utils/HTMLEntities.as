/*

  Version: MPL 1.1/GPL 2.0/LGPL 2.1
 
  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is VEGAS Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <ekameleon@gmail.com>.
  Portions created by the Initial Developer are Copyright (C) 2004-2011
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
  Alternatively, the contents of this file may be used under the terms of
  either the GNU General Public License Version 2 or later (the "GPL"), or
  the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
  in which case the provisions of the GPL or the LGPL are applicable instead
  of those above. If you wish to allow use of your version of this file only
  under the terms of either the GPL or the LGPL, and not to allow others to
  use your version of this file under the terms of the MPL, indicate your
  decision by deleting the provisions above and replace them with the notice
  and other provisions required by the LGPL or the GPL. If you do not delete
  the provisions above, a recipient may use your version of this file under
  the terms of any one of the MPL, the GPL or the LGPL.
  
*/

package org.lala.compilercompile.utils
{
    /**
     * This static tool class encode or decode the HTML entities in a string.
     */
    public class HTMLEntities 
    {
        /**
         * Determinates all entities.
         */
        public static var entities:Array = 
        [ 
            "&euro;"   , "&quot;"   , "&apos;"   , "&amp;"    , "&lt;"     , "&gt;"     , "&iexcl;"  , "&cent;"   , "&pound;"  , "&curren;" , 
            "&yen;"    , "&brvbar;" , "&sect;"   , "&uml;"    , "&copy;"   , "&ordf;"   , "&not;"    , "&shy;"    , "&reg;"    , "&macr;"   , 
            "&deg;"    , "&plusmn;" , "&sup2;"   , "&sup3;"   , "&acute;"  , "&micro;"  , "&para;"   , "&middot;" , "&cedil;"  , "&sup1;"   , 
            "&ordm;"   , "&raquo;"  , "&frac14;" , "&frac12;" , "&frac34;" , "&iquest;" , "&Agrave;" , "&Aacute;" , "&Atilde;" , "&Auml;"   , 
            "&Aring;"  , "&AElig;"  , "&Ccedil;" , "&Egrave;" , "&Eacute;" , "&Ecirc;"  , "&Igrave;" , "&Iacute;" , "&Icirc;"  , "&Iuml;"   , 
            "&ETH;"    , "&Ntilde;" , "&Ograve;" , "&Oacute;" , "&Ocirc;"  , "&Otilde;" , "&Ouml;"   , "&times;"  , "&Oslash;" , "&Ugrave;" , 
            "&Uacute;" , "&Ucirc;"  , "&Uuml;"   , "&Yacute;" , "&THORN;"  , "&szlig;"  , "&agrave;" , "&aacute;" , "&acirc;"  , "&atilde;" , 
            "&auml;"   , "&aring;"  , "&aelig;"  , "&ccedil;" , "&egrave;" , "&eacute;" , "&ecirc;"  , "&euml;"   , "&igrave;" , "&iacute;" , 
            "&icirc;"  , "&iuml;"   , "&eth;"    , "&ntilde;" , "&ograve;" , "&oacute;" , "&ocirc;"  , "&otilde;" , "&ouml;"   , "&divide;" , 
            "&oslash;" , "&ugrave;" , "&uacute;" , "&ucirc;"  , "&uuml;"   , "&yacute;" , "&thorn;"  , "&nbsp;" 
        ] ;
        
        /**
         * Determinates all special chars.
         */
        public static var specialchars:Array = 
        [ 
            "€" , "\"", "'" , "&" , "<" , ">" , "¡" , "¢" , "£" , "¤" , "¥" , "¦" , "§" , "¨" , "©" , "ª" , "¬" , "­" , "®" , "¯" , "°" , 
            "±" , "²" , "³" , "´" , "µ" , "¶" , "·" , "¸" , "¹" , "º" , "»" , "¼" , "½" , "¾" , "¿" , "À" , "Á" , "Ã" , "Ä" , "Å" , "Æ" , 
            "Ç" , "È" , "É" , "Ê" , "Ì" , "Í" , "Î" , "Ï" , "Ð" , "Ñ" , "Ò" , "Ó" , "Ô" , "Õ" , "Ö" , "×" , "Ø" , "Ù" , "Ú" , "Û" , "Ü" , 
            "Ý" , "Þ" , "ß" , "à" , "á" , "â" , "ã" , "ä" , "å" , "æ" , "ç" , "è" , "é" , "ê" , "ë" , "ì" , "í" , "î" , "ï" , "ð" , "ñ" , 
            "ò" , "ó" , "ô" , "õ" , "ö" , "÷" , "ø" , "ù" , "ú" , "û" , "ü" , "ý" , "þ" , "\u00A0" 
        ] ;
        
        /**
         * Decodes the specified string.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import vegas.net.HTMLEntities  ;
         * trace( HTMLEntities.decode("&lt;b&gt;hello world&lt;/b&gt;" ) ) ; // <b>hello world</b>
         * </pre>
         * @return the decode string.
         */
        public static function decode( text:String, removeCRLF:Boolean=false ):String 
        {
            var ch:String ;
            var entity:String ;
            var i:int ;
            var len:int = entities.length ;
            for( i=0 ; i<len ; i++ )
            {
                ch = specialchars[ i ];
                entity = entities[ i ];
                if( text.indexOf( entity ) > -1 )
                {
                    text = text.replace( new RegExp( entity , "g" ) , ch );
                }
            }
            if( removeCRLF )
            {
                text = (text.split("\r\n")).join("") ;
            }
            return text;
        }
        
        /**
         * Encodes the specified text passed in argument.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import vegas.net.HTMLEntities  ;
         * trace( HTMLEntities.encode("<b>hello world</b>" ) ) ; // &lt;b&gt;hello world&lt;/b&gt;
         * </pre>
         * @return a string encode text.
         */
        public static function encode( text:String ):String
        {
            var ch:String ;
            var entity:String ;
            var i:int ;
            var len:int = entities.length ;
            for( i=0; i < len; i++ )
            {
                ch     = specialchars[i];
                entity = entities[i];
                if( text.indexOf( ch ) > -1 )
                {
                    text = text.replace( new RegExp( ch , "g" ) , entity );
                }
            }
            return text.toString() ;
        }
            
        /**
         * Returns the entity name of the specified character in argument.
         * Returns an empty string value if the char passed-in argument isn't a special char to transform in entity string representation.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import vegas.net.HTMLEntities  ;
         * trace( HTMLEntities.getCharToEntity("&#38;lt") ) ;
         * </pre>
         * @return the entity name of the specified character in argument.
         */
        public static function getCharToEntity( char:String ):String
        {
            var index:int = specialchars.indexOf( char.charAt(0) ) ;
            return index > -1 ? entities[index] : "" ;
        }
    
        /**
         * Returns the entity number string representation of the specified character in argument.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import vegas.net.HTMLEntities  ;
         * trace( HTMLEntities.getCharToEntityNumber("&#38;lt") ) ;
         * </pre>
         * @return the entity number string representation of the specified character in argument.
         */
        public static function getCharToEntityNumber( char:String ):String
        {
            return "&#" + char.charCodeAt(0) + ";" ;
        } 
        
        /**
         * Returns the char representation of the specified entity number string value in argument or an empty string value.
         * <p><b>Example :</b></p>
         * <pre class="prettyprint">
         * import vegas.net.HTMLEntities  ;
         * trace( HTMLEntities.getEntityNumberToChar("&#38;#60;")) ; // &lt;
         * </pre>
         * @return the char representation of the specified entity number string value in argument or an empty string value.
         */
        public static function getEntityNumberToChar( entityNumber:String ):String
        {
            if ( entityNumber.charAt(0) == "&" && entityNumber.charAt(1) == "#" && entityNumber.charAt(entityNumber.length - 1) == ";" ) 
            {
                return String.fromCharCode( parseInt( ( entityNumber.split("&#") )[1]) ) ;
            }
            else
            {
                return "" ;
            }
        }
    }
}
