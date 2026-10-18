# Model-View-Controller pattern (Flask exercise)

A small Flask app from Nick Russo's Pluralsight course on the
Model-View-Controller (MVC) pattern, set up in May 2020. "Globomantics" is the
fictional company the course uses: the app looks up a customer's account
balance from `data/db.yml` (JSON and XML versions are included too).

- `database.py` is the model, `templates/index.html` the view, and `start.py`
  the controller.
- Run it from this folder: `pip install flask pyyaml`, then `python start.py`
  and open http://localhost:5000.

It is unrelated to the EEG Visualizer and is kept here for history.
