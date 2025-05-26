import express from "express";
import mysql from "mysql2";
import cors from "cors";
const app = express();
app.use(express.json());
app.use(cors());
const db = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "kdm21awm29m12g19",
    database: "javasampledb"
});
app.get("/", (req, res) => {
})
app.get("/stu", (req, res) => {
    const query = "SELECT * FROM student";
    db.query(query, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    })
})
app.get("/stu/:pass/:uname", (req, res) => {
    const pass = req.params.pass;
    const name = req.params.uname;
    // const q = "SELECT * FROM student WHERE pass=? and username=?)";
    const q = "SELECT * FROM student WHERE (pass=? AND username=?) OR (pass=? AND email=?)";
    db.query(q,[pass,name,pass,name], (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    })
})

app.post("/stu", (req, res) => {
    let q = "INSERT INTO student(fname,mname,lname,username,email,pass,rule,balance) VALUES(?)";
    var resul = req.body;
    console.log("result=" + resul);
    console.log(resul.id);

    let val = [req.body.fname, req.body.mname, req.body.lname, req.body.username, req.body.email, req.body.pass,req.body.rule,req.body.balance];
    db.query(q, [val], (err, data) => {
        if (err) return res.json(err);
        res.json("STUDENT HAS BEEN CREATED SUCSSESFULLY");
    })
})
app.post("/subject", (req, res) => {
    let q = "INSERT INTO subject(name,grade,code,ch) VALUES(?)";
    // var resul = req.body;
    // console.log(resul);

    let val = [req.body.name, req.body.grade, req.body.code,req.body.ch];
    db.query(q, [val], (err, data) => {
        if (err) return res.json(err);
        res.json("SUBJECT HAS BEEN RIGESTER  SUCSSESFULLY");
    })
})
app.get("/subject", (req, res) => {
    const query = "SELECT * FROM subject ORDER BY grade ASC ";
    db.query(query, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
})
app.put("/subject/:id", (req, res) => {
    const q = "UPDATE subject SET name = ?, code = ?, ch = ?, grade = ? WHERE id = ?";
    const id = req.params.id;

    const val = [req.body.name, req.body.code, req.body.ch, req.body.grade, id];

    db.query(q, val, (err, data) => {
        if (err) return res.json(err);
        res.json("SUBJECT HAS BEEN UPDATED SUCCESSFULLY");
    });
});
app.delete("/subject/:id", (req, res) => {
    const idn = req.params.id;
    const q = "DELETE FROM subject WHERE id=?";
    db.query(q, idn, (err, data) => {
        if (err) return res.json(err);
        res.json("STUDENT HAS BEEN Delated SUCSSESFULLY");


    })
})


app.get("/subject/:id", (req, res) => {
    const query = "SELECT * FROM subject where grade=?";
    var grade=req.params.id;
    db.query(query,grade, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
})
app.get("/subject/serch/:id", (req, res) => {
    const query = "SELECT * FROM subject where id=?";
    var grade=req.params.id;
    db.query(query,grade, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
})

app.post("/quize", (req, res) => {
    let q = "INSERT INTO quize(question,questiontype,choices,answer,subjectid) VALUES(?)";
    var resul = req.body;

    let val = [req.body.question, req.body.questiontype, req.body.choices,req.body.answer, req.body.subjectid];

    db.query(q, [val], (err, data) => {
        if (err) return res.json(err);
        res.json("SUBJECT HAS BEEN RIGESTER  SUCSSESFULLY");
    })
})
app.get("/quize", (req, res) => {
    const query = "SELECT * FROM quize";
    db.query(query, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
})
app.get("/quize/:t", (req, res) => {
    const query = "SELECT * FROM quize where questiontype=?";
    var type=req.params.t;
    db.query(query,type, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
})
app.put("/quize/:id", (req, res) => {
    const q = "UPDATE quize SET question = ?, questiontype = ?, choices = ?, answer = ?, subjectid = ? WHERE id = ?";
    const id = req.params.id;

    const val = [
        req.body.question,
        req.body.questiontype,
        req.body.choices,
        req.body.answer,
        req.body.subjectid,
        id
    ];

    db.query(q, val, (err, data) => {
        if (err) return res.status(500).json(err);
        res.json("Quiz has been updated successfully");
    });
});
app.delete("/quize/:id", (req, res) => {
    const idn = req.params.id;
    const q = "DELETE FROM quize WHERE id=?";
    db.query(q, idn, (err, data) => {
        if (err) return res.json(err);
        res.json("QUIZE  Delated SUCSSESFULLY");


    })
})





app.post("/titory", (req, res) => {
    let q = "INSERT INTO titorl(title,note,sid,chapter,part) VALUES(?)";
    // var resul = req.body;
    // console.log(resul);

    let val = [req.body.title, req.body.note, req.body.sid,req.body.chapter,req.body.part];
    db.query(q, [val], (err, data) => {
        if (err) return res.json(err);
        res.json("SUBJECT HAS BEEN RIGESTER  SUCSSESFULLY");
    })
})
app.get("/titory", (req, res) => {
    const query = "SELECT * FROM titorl";
    db.query(query, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
})
app.put("/titory/:id", (req, res) => {
    const q = "UPDATE subject SET name = ?, code = ?, ch = ?, grade = ? WHERE id = ?";
    const id = req.params.id;

    const val = [req.body.name, req.body.code, req.body.ch, req.body.grade, id];

    db.query(q, val, (err, data) => {
        if (err) return res.json(err);
        res.json("SUBJECT HAS BEEN UPDATED SUCCESSFULLY");
    });
});
app.delete("/titory/:id", (req, res) => {
    const idn = req.params.id;
    const q = "DELETE FROM subject WHERE id=?";
    db.query(q, idn, (err, data) => {
        if (err) return res.json(err);
        res.json("STUDENT HAS BEEN Delated SUCSSESFULLY");


    })
})

app.get("/titory/:id", (req, res) => {
    const query = "SELECT * FROM titorl where sid=?";
    var grade=req.params.id;
    // print(grade);
    console.log(grade);
    db.query(query,grade, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
})



app.get("/stu/:id", (req, res) => {
    const idn = req.params.id;
    const q = "SELECT * FROM student WHERE id=?";
    console.log(idn);
    db.query(q, idn, (err, data) => {
        // console.log(data);

        if (err) return res.json(err);
        res.json(data);

    })
})
app.delete("/stu/:id", (req, res) => {
    const idn = req.params.id;
    const q = "DELETE FROM student WHERE id=?";
    db.query(q, idn, (err, data) => {
        if (err) return res.json(err);
        res.json("STUDENT HAS BEEN Delated SUCSSESFULLY");


    })
})

app.put("/stu/:id/", (req, res) => {
    const idn = req.params.id;
    const q = "UPDATE stu SET id=?,fname=?,mname=?,lname=?,username=?,email=?,pass=?,rule=?,balance=?";
    let val = [req.body.id, req.body.name, req.body.mname, req.body.lname, req.body.age, req.body.gender, req.body.dep];
    db.query(q, [...val, idn], (err, data) => {
        if (err) return res.json(err);
        res.json("STUDENT HAS BEEN Delated SUCSSESFULLY");


    })
})





app.post("/assignments", (req, res) => {
    let q = "INSERT INTO assignments(title,description,subject,due_date) VALUES(?)";
    // var resul = req.body;
    // console.log(resul);

    let val = [req.body.title, req.body.description, req.body.subject,req.body.dueDate];
    db.query(q, [val], (err, data) => {
        if (err) return res.json(err);
        res.json("SUBJECT HAS BEEN RIGESTER  SUCSSESFULLY");
    })
})
app.get("/assignments", (req, res) => {
    const query = "SELECT * FROM assignments ";
    db.query(query, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
})
app.put("/assignments/:id", (req, res) => {
    const q = "UPDATE assignments SET title = ?, description = ?, subject = ?, due_date = ? WHERE id = ?";
    const id = req.params.id;

    let val = [req.body.title, req.body.description, req.body.subject,req.body.dueDate,id];

    db.query(q, val, (err, data) => {
        if (err) return res.json(err);
        res.json("SUBJECT HAS BEEN UPDATED SUCCESSFULLY");
    });
});
app.delete("/assignments/:id", (req, res) => {
    const idn = req.params.id;
    const q = "DELETE FROM assignments WHERE id=?";
    db.query(q, idn, (err, data) => {
        if (err) return res.json(err);
        res.json("STUDENT HAS BEEN Delated SUCSSESFULLY");


    })
})
app.get("/assignments/:id", (req, res) => {
    const query = "SELECT * FROM assignments where subject=?";
    var grade=req.params.id;
    db.query(query,grade, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
})



app.get("/reports", (req, res) => {
    const query = "SELECT * FROM reports ";
    db.query(query, (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });

})
app.get("/reports/:ei", (req, res) => {
    const query = "SELECT * FROM reports where emailin=? or emailout=? ";
const ei = req.params.ei;
    db.query(query,[ei,ei], (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
    
})
app.get("/reports/:ei/:eo", (req, res) => {
    const query = "SELECT * FROM reports where (emailin=? AND emailout=?) OR(emailin=? AND emailout=?) ORDER BY id DESC ";
const ei = req.params.ei;
const eo = req.params.eo;
    db.query(query,[ei,eo,eo,ei], (err, data) => {
        if (err) return res.json(err);
        res.json(data);
    });
    
})

app.post("/reports", (req, res) => {
    let q = "INSERT INTO reports(message,emailin,emailout) VALUES(?)";
    // var resul = req.body;
    // console.log(resul);

    let val = [req.body.message, req.body.emailin, req.body.emailout];
    console.log(val);
    db.query(q, [val], (err, data) => {
        if (err) return res.json(err);
        res.json("Message Send  SUCSSESFULLY");
    })
})
app.listen(8800, () => {
    console.log("connect on port 8800");
})