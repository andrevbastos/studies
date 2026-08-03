from sqlalchemy.orm import Session, DeclarativeBase, Mapped, mapped_column
from sqlalchemy import create_engine, select

class Base(DeclarativeBase):
    pass

class Client(Base):
    __tablename__ = "clients"

    id: Mapped[int] = mapped_column(primary_key=True)
    name: Mapped[str] = mapped_column()
    email: Mapped[str] = mapped_column()

def main():
    engine = create_engine("sqlite:///py-orm.db")
    Base.metadata.create_all(engine)

    with Session(engine) as session:
        sel = select(Client)
        clients = session.execute(sel).scalars().all()
        for client in clients:
            print(client.name)

if __name__ == "__main__":
    main()