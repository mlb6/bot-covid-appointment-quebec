var imaps = require('imap-simple');


var config = {
    imap: {
        user: process.env.IMAP_USER,
        password: process.env.IMAP_PASSWORD,
        host: process.env.IMAP_HOST || 'imap.gmail.com',
        port: parseInt(process.env.IMAP_PORT || '993'),
        tls: true,
        tlsOptions: { rejectUnauthorized: false },
        authTimeout: 3000
    }
};

const ELAPSEDTIME = 2*60*1000;

(async function  (){
    try {
        const connection = await imaps.connect(config);
        await connection.openBox('INBOX');
        var searchCriteria = [ 'UNSEEN', ['SUBJECT', (process.env.EMAIL_SUBJECT || 'Confirmation d\'identité')] ];
        var fetchOptions = {
            bodies: ['TEXT']
        };
        let code=null;
        while (code===null) {
            //console.log('searching');
            const messages  = await connection.search(searchCriteria, fetchOptions);
            messages.sort((a, b) => {
                return new Date(b.attributes.date) - new Date(a.attributes.date)
            })
            for (const message of messages) {

                if((new Date() - new Date(message.attributes.date)) > ELAPSEDTIME) {
                    //console.log('Older message: '+ message.attributes.date+ ' '+ code);
                    continue;
                }
                const textParts = message.parts.filter((part) => part.which === 'TEXT');
                const { body } = textParts[0];


                const regex = /.*\r\n\s+(\d{6})\r\n.*/gm;
                const matches = regex.exec(body);
                if (matches && matches.length >=2) {
                    code = matches[1];
                    break;
                }
            }
            if(code===null) {
                //console.log('pause');
                await new Promise(r => setTimeout(r, 2000));
            }
        }
        connection.end();
        console.log(code);
    } catch (e) {
        console.error(e);
    }
})();

