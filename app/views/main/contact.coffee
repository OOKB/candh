React = require 'react'
{section, div, h2, p, a, script, ul, li} = require 'reactionary'

data = require '../../data/contact.json'

module.exports = React.createClass

  render: ->
    section
      id: 'contact',
        h2 'Contact'
        ul
          className: 'contact-info',
            li 'Phone: '+data.phone
            li 'Fax: '+data.fax

        div
          id: 'wufoo-syft7fo1kebp41',
            a
              href: 'https://sundaysenergy.wufoo.com/forms/syft7fo1kebp41/',
                'Fill out our contact form'
        script
          type: 'text/javascript'
          dangerouslySetInnerHTML:
            __html:
              "var syft7fo1kebp41;
              (function(d, t) {
              var s = d.createElement(t), options = {
                'userName':'sundaysenergy',
                'formHash':'syft7fo1kebp41',
                'autoResize':true,
                'height':'976',
                'async':true,
                'host':'wufoo.com',
                'header':'hide',
                'ssl':true};
              s.src = ('https:' == d.location.protocol ? 'https://' : 'http://') + 'www.wufoo.com/scripts/embed/form.js';
              s.onload = s.onreadystatechange = function() {
              var rs = this.readyState; if (rs) if (rs != 'complete') if (rs != 'loaded') return;
              try {
                k1w15b2z04cgvvi = new WufooForm();
                k1w15b2z04cgvvi.initialize(options);
                k1w15b2z04cgvvi.display(); } catch (e) {}};
              var scr = d.getElementsByTagName(t)[0], par = scr.parentNode; par.insertBefore(s, scr);
              })(document, 'script');"
